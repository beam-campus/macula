defmodule Edge.Client do
  use Slipstream

  @moduledoc """
  Edge.Client is the client-side of the SwaiEdge.Socket server.
  It is part of the main application supervision tree.
  """
  require Logger

  alias Edge.Facts, as: EdgeFacts
  # alias Edge.Hopes, as: EdgeHopes
  alias Swai.Registry, as: EdgeRegistry
  alias Edge.System, as: EdgeServer
  alias Edge.Init, as: EdgeInit
  alias Phoenix.PubSub, as: PubSub

  @edge_lobby "edge:lobby"
  @edge_attached_v1 EdgeFacts.edge_attached_v1()
  @presence_changed_v1 EdgeFacts.presence_changed_v1()
  @edge_facts EdgeFacts.edge_facts()

  @scape_lobby "scape:lobby"

  # @socket_reconnect_delay 1_000

  # @joined_edge_lobby "edge:lobby:joined"

  ############# API ################
  def publish(edge_id, event, payload) do
    # Logger.warning("Edge.Client publish:  #{inspect(event)}")

    GenServer.cast(
      via(edge_id),
      {:publish, @edge_lobby, event, payload}
    )
  end

  def request(edge_id, hope, payload) do
    # Logger.warning("Edge.Client request:  #{inspect(hope)}")

    case GenServer.call(
           via(edge_id),
           {:request, @edge_lobby, hope, payload}
         ) do
      {:ok, reply} ->
        {:ok, reply}

      {:error, _reason} ->
        {:ok, nil}
    end
  end

  def join_ring(edge_id, scape_init) do
    GenServer.cast(
      via(edge_id),
      {:join_ring, scape_init}
    )
  end

  ############# CALLBACKS ################
  @impl Slipstream
  def handle_call({:request, topic, hope, payload}, _from, socket) do
    resp =
      socket
      |> push!(topic, hope, payload)
      |> await_reply!()

    {:reply, resp, socket}
  end

  @impl Slipstream
  def handle_cast({:publish, topic, event, payload}, socket) do
    case socket
         |> push(topic, event, payload) do
      # {%RuntimeError{message: message}, _} ->
      #   Logger.warning("Edge.Client push error: #{message}")
      #   {:noreply, socket}

      {:error, reason} ->
        Logger.warning("Edge.Client error: #{inspect(reason)}")
        {:noreply, socket}

      _push_ref ->
        {:noreply, socket}
    end
  end

  @impl Slipstream
  def handle_cast({:join_ring, %{scape_id: scape_id} = scape_init}, socket) do
    Logger.debug("Edge.Client JOIN RING: #{inspect(scape_id, pretty: true)}")

    socket
    |> join(@scape_lobby, scape_init)

    {:noreply, socket}
  end

  @impl Slipstream
  def init(%{edge_init: edge_init, config: config}) do
    {:ok, socket} =
      new_socket()
      |> assign(:edge_init, edge_init)
      |> assign(:config, config)
      |> connect(config)

    Logger.info("Edge.Client is up")

    {:ok, socket, {:continue, :start_ping}}
  end

  @impl Slipstream
  def handle_connect(socket) do
    edge_init = socket.assigns.edge_init

    joined_socket =
      socket
      |> join(@edge_lobby, edge_init)

    {:ok, joined_socket}
  end

  @impl Slipstream
  def handle_join(@edge_lobby, join_response, socket) do
    Process.send_after(self(), {:after_join, join_response}, 1_000)
    {:ok, socket}
  end

  @impl Slipstream
  def handle_disconnect(reason, socket) do
    Logger.warning("Edge.Client disconnected: #{inspect(reason)}")

    case reconnect(socket) do
      {:ok, socket} -> {:ok, socket}
      {:error, reason} -> {:stop, reason, socket}
    end
  end

  @impl Slipstream
  def handle_continue(:start_ping, socket) do
    {:noreply, socket}
  end

  @impl Slipstream
  def handle_info({:after_join, something}, socket) do
    Logger.debug("Edge.Client received: :after_join #{inspect(something)}")

    edge_init = socket.assigns.edge_init

    SwaiAco.EdgeApp.start_edge(edge_init)

    socket
    |> push!(@edge_lobby, @edge_attached_v1, %{edge_init: edge_init})

    :edge_pubsub
    |> PubSub.broadcast(@edge_facts, {@edge_attached_v1, edge_init})

    {:noreply, socket}
  end

  @impl Slipstream
  def handle_info({@presence_changed_v1, presence_list}, socket) do
    :edge_pubsub
    |> PubSub.broadcast(@edge_facts, {@presence_changed_v1, presence_list})

    {:noreply, socket}
  end

  @impl Slipstream
  def handle_info(_msg, socket) do
    {:noreply, socket}
  end

  @impl Slipstream
  def handle_message(room, message, params, socket) do
    EdgeServer.process_message(room, {message, params})
    {:ok, socket}
  end

  ############ PLUMBING ################
  def to_name(edge_id),
    do: "edge.client:#{edge_id}"

  def to_topic(edge_id),
    do: "edge:lobby:#{edge_id}"

  def via(edge_id),
    do: EdgeRegistry.via_tuple({:client, to_name(edge_id)})

  def child_spec(%EdgeInit{edge_id: edge_id} = edge_init) do
    config = Application.fetch_env!(:swai_edge, __MODULE__)

    %{
      id: to_name(edge_id),
      start: {__MODULE__, :start_link, [%{config: config, edge_init: edge_init}]},
      restart: :transient,
      type: :worker
    }
  end

  def start_link(%{edge_init: %EdgeInit{edge_id: edge_id}} = args),
    do:
      Slipstream.start_link(
        __MODULE__,
        args,
        name: via(edge_id)
      )
end

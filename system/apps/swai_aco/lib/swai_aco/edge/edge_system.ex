defmodule Edge.System do
  @moduledoc """
  This module is responsible for handling the events that are emitted by the SwaiAco
  """
  use GenServer

  require Logger

  alias Edge.Emitter, as: EdgeEmitter
  alias Edge.Facts, as: EdgeFacts
  alias Edge.Init, as: EdgeInit
  alias Phoenix.PubSub, as: PubSub
  alias Scape.Init, as: ScapeInit
  alias Swai.Registry, as: EdgeRegistry

  @edge_facts EdgeFacts.edge_facts()

  ##################### PUBLIC API #####################
  def start(%EdgeInit{} = edge_init) do
    case start_link(edge_init) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("EdgeSystem failed to start, reason: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def process_message(room, {message, params}),
    do:
      GenServer.cast(
        __MODULE__,
        {:process_message, {room, message, params}}
      )

  def get_scapes,
    do:
      GenServer.call(
        __MODULE__,
        :get_scapes
      )

  defp do_start_scape(%{edge_id: edge_id, scape_id: scape_id} = scape_init) do
    case Supervisor.start_child(
           via_sup(edge_id),
           {Scape.System, scape_init}
         ) do
      {:ok, _pid} ->
        Logger.info("Scape started: [#{scape_id}]")

      {:error, reason} ->
        Logger.error("Error starting scape: #{inspect(reason, pretty: true)}")
    end
  end

  ##################### START SCAPES ####################
  defp do_start_scapes(%EdgeInit{scapes_cap: scapes_cap} = edge_init) do
    1..scapes_cap
    |> Enum.each(fn scape_no ->
      case ScapeInit.new(scape_no, edge_init) do
        {:ok, scape_init} ->
          do_start_scape(scape_init)

        {:error, reason} ->
          Logger.error("Error creating Scape initialization: #{inspect(reason, pretty: true)}")
      end
    end)
  end

  ##################### INIT ####################
  @impl true
  def init(%{edge_id: edge_id} = edge_init) do
    Process.flag(:trap_exit, true)

    EdgeEmitter.emit_initializing_edge(edge_init)

    start_scapes =
      Task.async(fn -> do_start_scapes(edge_init) end)

    case Supervisor.start_link(
           [],
           name: via_sup(edge_id),
           strategy: :one_for_one
         ) do
      {:ok, pid} ->
        Task.await(start_scapes)
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Error starting edge system: #{inspect(reason, pretty: true)}")
        {:stop, reason}
    end

    EdgeEmitter.emit_edge_initialized(edge_init)

    Logger.debug("#{__MODULE__}:[#{edge_id}] is up: #{Colors.edge_theme(self())}")

    :edge_pubsub
    |> PubSub.subscribe(@edge_facts)

    {:ok, edge_init}
  end

  ########################## GET_SCAPES ############################
  @impl true
  def handle_call(:get_scapes, _from, %EdgeInit{edge_id: edge_id} = state) do
    scapes = Supervisor.which_children(via_sup(edge_id))
    {:reply, scapes, state}
  end

  ###################### PROCESS_MESSAGE ##############
  @impl true
  def handle_cast({:process_message, {room, message, params}}, state) do
    Logger.warning(
      "EdgeSystem received message: #{inspect({room, message, params}, pretty: true)}"
    )

    {:noreply, state}
  end

  ######### HANDLE CAST FALLBACK ###################
  @impl true
  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  ## EXIT of a child process ##################
  @impl true
  def handle_info({:EXIT, from_pid, reason}, state) do
    Logger.info(
      "#{Colors.red_on_black()}EXIT received from #{inspect(from_pid)} reason: #{inspect(reason)}#{Colors.reset()}"
    )

    {:noreply, state}
  end

  ## Edge Attached ############################
  @impl true
  def handle_info({:edge_attached, %{edge_id: edge_id}}, state) do
    Logger.info("Edge attached: [#{edge_id}]")
    {:noreply, state}
  end

  ## HANDLE_INFO FALLBACK #################
  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  ## PLUMBING ############################
  def via(key),
    do: EdgeRegistry.via_tuple({:edge_system, to_name(key)})

  def via_sup(key),
    do: EdgeRegistry.via_tuple({:edge_sup, to_name(key)})

  def to_name(key) when is_bitstring(key),
    do: "edge.system:#{key}"

  def child_spec(%EdgeInit{} = state) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start, [state]},
      type: :supervisor,
      restart: :transient
    }
  end

  def start_link(%EdgeInit{} = edge_init) do
    GenServer.start_link(
      __MODULE__,
      edge_init,
      name: __MODULE__
    )
  end
end

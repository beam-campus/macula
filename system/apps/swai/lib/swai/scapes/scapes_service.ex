defmodule Scapes.Service do
  use GenServer

  @moduledoc """
  Scapes.Service contains the GenServer for the Server.
  """

  require Cachex
  require Logger

  alias Hives.Service, as: Hives
  alias Phoenix.PubSub, as: PubSub
  alias Scape.Facts, as: ScapeFacts
  alias Scape.Init, as: ScapeInit
  alias Scape.Status, as: ScapeStatus
  alias Schema.SwarmLicense, as: License

  @scape_facts ScapeFacts.scape_facts()

  @initializing_scape_v1 ScapeFacts.scape_initializing_v1()
  @scape_initialized_v1 ScapeFacts.scape_initialized_v1()
  @scape_detached_v1 ScapeFacts.scape_detached_v1()
  @scape_attached_v1 ScapeFacts.scape_attached_v1()

  @scapes_cache_facts ScapeFacts.scapes_cache_facts()

  ############################ INIT ##############################
  @impl true
  def init(init_args) do
    Logger.info("STARTED Scapes.Service. #{inspect(self())} LISTENING for #{@scape_facts}")

    Swai.PubSub
    |> PubSub.subscribe(@scape_facts)

    {:ok, init_args}
  end

  #################### PUBLIC API ##################
  def hydrate_license(license), do: GenServer.call(__MODULE__, {:hydrate_license, license})
  def get_all, do: GenServer.call(__MODULE__, :get_all)
  def get_stream, do: GenServer.call(__MODULE__, :get_stream)
  def get_summary, do: GenServer.call(__MODULE__, :get_summary)
  def get_for_edge(edge_id), do: GenServer.call(__MODULE__, {:get_for_edge, edge_id})
  def save_scape(scape_init), do: GenServer.cast(__MODULE__, {:save_scape, scape_init})
  def count, do: GenServer.call(__MODULE__, {:count})
  def get_by_id!(scape_id), do: GenServer.call(__MODULE__, {:get_by_id, scape_id})

  #################### SAVE_SCAPE ##################
  @impl true
  def handle_cast({:save_scape, %{scape_id: scape_id} = scape} = cause, state) do
    :scapes_cache
    |> Cachex.put!(scape_id, scape)

    notify_cache_updated(cause)

    {:noreply, state}
  end

  #################### GET_BY_ID ##################
  @impl true
  def handle_call({:get_by_id, scape_id}, _from, state) do
    scape =
      :scapes_cache
      |> Cachex.get!(scape_id)

    {:reply, scape, state}
  end

  #################### HYDRATE ###############################
  @impl true
  def handle_call({:hydrate_license, %{scape_id: nil} = license}, _from, state) do
    result = ScapeInit.default()

    new_license =
      %License{license | scape_id: result.scape_id, scape: result}

    {:reply, new_license, state}
  end

  @impl true
  def handle_call(
        {:hydrate_license, %{scape_id: scape_id} = license},
        _from,
        state
      ) do
    scape =
      :scapes_cache
      |> Cachex.get!(scape_id)
      |> Hives.hydrate_scape()

    new_license =
      %License{
        license
        | scape: scape
      }

    {:reply, new_license, state}
  end

  @impl true
  def handle_call({:count}, _from, state) do
    result =
      :scapes_cache
      |> Cachex.stream!()
      |> Enum.count()

    {:reply, result, state}
  end

  #################### GET ALL ###############################
  @impl true
  def handle_call(:get_all, _from, state) do
    result =
      :scapes_cache
      |> Cachex.stream!()
      |> Enum.map(fn {:entry, _id, _internal_key, _nil, scape} -> scape end)

    {:reply, result, state}
  end

  #################### GET STREAM ###############################
  @impl true
  def handle_call(:get_stream, _from, state) do
    result =
      :scapes_cache
      |> Cachex.stream!()

    {:reply, result, state}
  end

  #################### GET SUMMARY ###############################
  @impl true
  def handle_call(:get_summary, _from, %ScapeInit{scape_id: scape_id} = state) do
    result =
      :scapes_cache
      |> Cachex.stream!()
      |> Stream.map(fn {:entry, _, _, _, scape} -> scape end)
      |> Enum.reduce(%{}, fn _scape, acc -> Map.update(acc, scape_id, 1, &(&1 + 1)) end)
      |> Map.to_list()
      |> Enum.sort()

    {:reply, result, state}
  end

  ################# GET_FOR_EDGE ##############
  @impl true
  def handle_call({:get_for_edge, edge_id}, _from, state) do
    case :scapes_cache
         |> Cachex.stream!()
         |> Stream.filter(fn {:entry, _key, _nil, _internal_id, scape} ->
           scape.edge_id == edge_id
         end)
         |> Enum.map(fn {:entry, _key, _nil, _internal_id, scape} -> scape end) do
      [] ->
        {:reply, [], state}

      scapes ->
        {:reply, scapes, state}
    end
  end

  ####################### INITIALIZING SCAPE #######################
  @impl true
  def handle_info({@initializing_scape_v1, %{scape_id: scape_id} = scape} = cause, state) do
    new_scape = %ScapeInit{
      scape
      | scape_status: ScapeStatus.initializing()
    }

    :scapes_cache
    |> Cachex.put!(scape_id, new_scape)

    notify_cache_updated(cause)

    {:noreply, state}
  end

  ####################### INITIALIZED SCAPE #######################
  @impl true
  def handle_info({@scape_initialized_v1, %{scape_id: scape_id} = scape} = cause, state) do
    new_scape = %ScapeInit{
      scape
      | scape_status: ScapeStatus.initialized()
    }

    :scapes_cache
    |> Cachex.put!(scape_id, new_scape)

    notify_cache_updated(cause)

    {:noreply, state}
  end

  ####################### ATTACHED SCAPE #######################
  @impl true
  def handle_info({@scape_attached_v1, %{scape_id: scape_id} = scape} = cause, state) do
    new_scape = %ScapeInit{
      scape
      | scape_status: ScapeStatus.attached()
    }

    :scapes_cache
    |> Cachex.put!(scape_id, new_scape)

    notify_cache_updated(cause)

    {:noreply, state}
  end

  ####################### DETACHED SCAPE #######################
  @impl true
  def handle_info({@scape_detached_v1, %ScapeInit{scape_id: scape_id}} = cause, state) do
    :scapes_cache
    |> Cachex.del!(scape_id)

    notify_cache_updated(cause)

    {:noreply, state}
  end

  ####################### UNHANDLED MESSAGES #######################
  @impl true
  def handle_info(msg, state) do
    Logger.warning("Scapes Service: Unhandled message => #{inspect(msg)}")
    {:noreply, state}
  end

  ####################### TERMINATE #######################
  @impl true
  def terminate(_reason, state) do
    {:ok, state}
  end

  ###################  PRIVATE  ###################
  defp notify_cache_updated(cause) do
    Swai.PubSub
    |> PubSub.broadcast!(@scapes_cache_facts, {:scapes, cause})
  end

  ###################  PLUMBING  ###################

  def start_link() do
    GenServer.start_link(
      __MODULE__,
      [],
      name: __MODULE__
    )
  end

  def child_spec(_scape_init) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent
    }
  end
end

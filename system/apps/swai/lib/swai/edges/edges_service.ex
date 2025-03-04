# Credits: Special thanks to @cmo and @al2o3cr for the help on this one.

defmodule Edges.Service do
  use GenServer

  @moduledoc """
  The Cache module is used to store and retrieve data from the Edges ETS cache.
  """

  alias Edge.Facts, as: EdgeFacts
  alias Edge.Init, as: EdgeInit
  alias Edge.Status, as: EdgeStatus
  alias Phoenix.PubSub, as: PubSub
  alias Schema.EdgeStats, as: EdgeStats
  alias Schema.SwarmLicense, as: License

  require Colors
  require Logger

  @edge_facts EdgeFacts.edge_facts()
  @edges_cache_facts EdgeFacts.edges_cache_facts()
  @edge_attached_v1 EdgeFacts.edge_attached_v1()
  @edge_detached_v1 EdgeFacts.edge_detached_v1()

  @edge_status_attached EdgeStatus.edge_attached()
  @edge_status_detached EdgeStatus.edge_detached()

  def start do
    case start_link(nil) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Edges.Service failed to start: #{reason}")
        {:error, reason}
    end
  end

  def count, do: GenServer.call(__MODULE__, :count)
  def get_all, do: GenServer.call(__MODULE__, :get_all)
  def get_stats, do: GenServer.call(__MODULE__, :get_stats)
  def get_by_id(edge_id), do: GenServer.call(__MODULE__, {:get_by_id, edge_id})
  def get_by_id!(edge_id), do: GenServer.call(__MODULE__, {:get_by_id, edge_id})
  def hydrate_license(license), do: GenServer.call(__MODULE__, {:hydrate_license, license})
  defp do_get_edge!(%{edge_id: edge_id}), do: :edges_cache |> Cachex.get!(edge_id)

  ############## CALLBACKS #########
  @impl GenServer
  def init(args \\ []) do
    Logger.warning("Edges.Service is up
    => #{Colors.edge_theme(self())}")
    Swai.PubSub |> PubSub.subscribe(@edge_facts)
    {:ok, args}
  end

  @impl GenServer
  def handle_call(:count, _from, state), do: {:reply, :edges_cache |> Cachex.size!(), state}

  @impl GenServer
  def handle_call(:get_all, _from, state),
    do:
      {:reply,
       :edges_cache
       |> Cachex.stream!()
       |> Enum.map(fn {:entry, _key, _nil, _internal_key, edge} -> edge end), state}

  @impl GenServer
  def handle_call({:get_by_id, nil}, _from, state) do
    {:reply, EdgeInit.default(), state}
  end

  @impl GenServer
  def handle_call({:get_by_id, edge_id}, _from, state) do
    case :edges_cache
         |> Cachex.get!(edge_id) do
      nil -> {:reply, EdgeInit.default(), state}
      edge -> {:reply, edge, state}
    end
  end

  @impl GenServer
  def handle_call(:get_stats, _from, state),
    do: {:reply, :edges_cache |> Cachex.stats!(), state}

  ################### HYDRATE ###################
  @impl GenServer
  def handle_call({:hydrate_license, %{edge_id: nil} = license}, _from, state),
    do: {
      :reply,
      %License{
        license
        | edge_id: nil,
          edge: EdgeInit.default()
      },
      state
    }

  @impl GenServer
  def handle_call({:hydrate_license, %{edge_id: edge_id} = license}, _from, state) do
    found_edge =
      case :edges_cache |> Cachex.get!(edge_id) do
        nil -> EdgeInit.default()
        edge -> edge
      end

    new_license = %License{license | edge: found_edge}

    {:reply, new_license, state}
  end

  ##################### HANDLE EDGE ATTACHED ###################
  @impl GenServer
  def handle_info({@edge_attached_v1, %EdgeInit{edge_id: edge_id} = edge_init} = cause, _state) do
    state =
      case do_get_edge!(edge_init) do
        nil ->
          new_edge =
            %EdgeInit{
              edge_init
              | stats: %EdgeStats{nbr_of_agents: 1},
                edge_status: @edge_status_attached
            }

          :edges_cache
          |> Cachex.put!(edge_id, new_edge)

        old ->
          %{stats: %EdgeStats{} = old_stats} = old
          new_stats = %EdgeStats{old_stats | nbr_of_agents: old_stats.nbr_of_agents + 1}
          new_edge = %EdgeInit{old | stats: new_stats, edge_status: @edge_status_attached}

          :edges_cache
          |> Cachex.update!(edge_id, new_edge)
      end

    notify_edges_updated(cause)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(
        {@edge_detached_v1, %EdgeInit{} = edge_init} =
          cause,
        _state
      ) do
    ###################################################################### #
    # @edge_detached_v1 does not remove the edge entry from the cache it only
    # decrements the number of agents on the edge. # If the number of agents on
    # the edge is 0, the edge is removed from the cache.
    ######################################################################
    # Logger.debug("Edge detached: #{inspect(edge_init)}")
    state =
      case do_get_edge!(%EdgeInit{edge_id: edge_id} = edge_init) do
        nil ->
          "nothing to detach"

        old_edge ->
          %{stats: %EdgeStats{} = old_stats} = old_edge

          new_stats = %EdgeStats{old_stats | nbr_of_agents: old_stats.nbr_of_agents - 1}

          %EdgeInit{} =
            new_edge = %EdgeInit{old_edge | stats: new_stats, edge_status: @edge_status_detached}

          :edges_cache |> Cachex.update!(edge_id, new_edge)

          notify_edges_updated(cause)

          if new_edge.stats.nbr_of_agents == 0 do
            Process.send_after(self(), {:remove_edge, new_edge}, 10_000)
          end

          "edge node [#{edge_id}] detached"
      end

    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:remove_edge, %EdgeInit{edge_id: edge_id} = edge_init}, _state) do
    state = :edges_cache |> Cachex.del!(edge_id)

    notify_edges_updated({:remove_edge, edge_init})
    {:noreply, state}
  end

  ################### SUBSCRIPTIONS FALLTHROUGH ###################
  @impl GenServer
  def handle_info(_msg, state), do: {:noreply, state}

  ############ INTERNALS ########
  defp notify_edges_updated(cause),
    do:
      Swai.PubSub
      |> PubSub.broadcast!(@edges_cache_facts, {:edges, cause})

  ########### PLUMBING ##########

  def child_spec,
    do: %{id: __MODULE__, start: {__MODULE__, :start, []}, type: :worker, restart: :permanent}

  def start_link(_args), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)
end

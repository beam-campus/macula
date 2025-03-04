defmodule Arenas.Service do
  @moduledoc false
  use GenServer

  require Logger

  alias Arena.Facts, as: ArenaFacts
  alias Arena.Init, as: ArenaInit
  alias Arena.Status, as: ArenaStatus
  alias Phoenix.PubSub, as: PubSub
  alias Scape.Facts, as: ScapeFacts
  alias Schema.SwarmLicense, as: License

  @arena_facts ArenaFacts.arena_facts()
  @arenas_cache_facts ArenaFacts.arenas_cache_facts()
  @arena_initialized_v1 ArenaFacts.arena_initialized_v1()
  @arena_status_initialized ArenaStatus.arena_initialized()

  @scape_facts ScapeFacts.scape_facts()
  @scape_detached_v1 ScapeFacts.scape_detached_v1()

  ## Public API
  def hydrate(license), do: GenServer.call(__MODULE__, {:hydrate, license})

  def get_for_scape!(nil),
    do: ArenaInit.default()

  def get_for_scape!(scape_id),
    do:
      GenServer.call(
        __MODULE__,
        {:get_for_scape, scape_id}
      )

  def get_all,
    do:
      GenServer.call(
        __MODULE__,
        :get_all
      )

  def start(cache_file) do
    case start_link(cache_file) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  ## API CALLS

  ####################### HYDRATE #######################

  @impl GenServer
  def handle_call({:hydrate, %{scape_id: nil} = license}, _from, cache_file) do
    the_arena = ArenaInit.default()
    new_license = %License{license | arena: the_arena}
    {:reply, new_license, cache_file}
  end

  @impl GenServer
  def handle_call({:hydrate, %{scape_id: scape_id} = license}, _from, cache_file) do
    the_arena =
      :arenas_cache
      |> Cachex.get!(scape_id)

    new_license = %License{license | arena: the_arena}

    {:reply, new_license, cache_file}
  end

  ####################### GET ALL #######################
  @impl GenServer
  def handle_call(:get_all, _from, cache_file) do
    reply =
      :arenas_cache
      |> Cachex.stream!()
      |> Stream.map(fn {:entry, _, _, _, arena} -> arena end)
      |> Enum.to_list()

    {:reply, reply, cache_file}
  end

  ####################### GET FOR SCAPE #######################
  @impl GenServer
  def handle_call({:get_for_scape, scape_id}, _from, cache_file) do
    arena =
      :arenas_cache
      |> Cachex.get!(scape_id)

    {:reply, arena, cache_file}
  end

  ####################### SUBSCRIBED FACTS ################
  @impl GenServer
  def handle_info(
        {@arena_initialized_v1,
         %Arena.Init{
           scape_id: scape_id
         } = arena_init} = cause,
        state
      ) do
    new_arena =
      %ArenaInit{arena_init | arena_status: @arena_status_initialized}

    :arenas_cache
    |> Cachex.put!(scape_id, new_arena)

    notify_cache_updated(cause)

    {:noreply, state}
  end

  ################### SCAPE DETACHED ####################
  @impl GenServer
  def handle_info({@scape_detached_v1, %{scape_id: scape_id}} = cause, state) do
    Logger.alert("Scape Detached, deleting arenas for #{scape_id}")

    :arenas_cache
    |> Cachex.stream!()
    |> Stream.filter(fn {:entry, _, _, _, arena_init} ->
      arena_init.scape_id == scape_id
    end)
    |> Enum.each(fn {:entry, arena_id, _, _, _} ->
      :arenas_cache
      |> Cachex.del!(arena_id)
    end)

    notify_cache_updated(cause)
    {:noreply, state}
  end

  ## FALLTHROUGHS
  @impl GenServer
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp notify_cache_updated(cause) do
    Swai.PubSub
    |> PubSub.broadcast!(
      @arenas_cache_facts,
      {:arena, cause}
    )
  end

  ################### PLUMBING ####################
  @impl GenServer
  def init(cache_file) do
    Process.flag(:trap_exit, true)

    Swai.PubSub
    |> PubSub.subscribe(@arena_facts)

    Swai.PubSub
    |> PubSub.subscribe(@scape_facts)

    {:ok, cache_file}
  end

  defp start_link(cache_file),
    do:
      GenServer.start_link(
        __MODULE__,
        cache_file,
        name: __MODULE__
      )

  def child_spec(cache_file),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start, [cache_file]},
      type: :supervisor,
      restart: :transient
    }
end

defmodule Regions.Service do
  use GenServer

  @moduledoc """
  The server for the regions Cache.
  """

  alias Phoenix.PubSub
  alias Region.Facts, as: RegionFacts

  require Logger
  require Cachex

  @initializing_region_v1 RegionFacts.initializing_region_v1()
  @regions_cache_updated_v1 RegionFacts.regions_cache_updated_v1()

  ########### PUBLIC API ##########

  def get_all(),
    do:
      GenServer.call(
        __MODULE__,
        {:get_all}
      )

  def get_stream(),
    do:
      GenServer.call(
        __MODULE__,
        {:get_stream}
      )

  def count(),
    do:
      GenServer.call(
        __MODULE__,
        {:count}
      )

  ########### CALLBACKS ###########
  @impl GenServer
  def init(opts) do
    Logger.info("Starting regions cache")

    # :regions_cache
    # |> Cachex.start()

    PubSub.subscribe(Swai.PubSub, @initializing_region_v1)

    {:ok, opts}
  end

  ################### handle_call ###################
  @impl GenServer
  def handle_call({:get_all}, _from, state) do
    {
      :reply,
      :regions_cache
      |> Cachex.stream!()
      |> Enum.map(fn {:entry, _key, _nil, _internal_id, region_init} -> region_init end),
      state
    }
  end

  @impl GenServer
  def handle_call({:get_stream}, _from, state) do
    {
      :reply,
      :regions_cache
      |> Cachex.stream!(),
      state
    }
  end


  @impl GenServer
  def handle_call({:count}, _from, state) do
    {
      :reply,
      :regions_cache
      |> Cachex.size!(),
      state
    }
  end

  ################### handle_info ###################
  @impl GenServer
  def handle_info({@initializing_region_v1, region_init}, state) do
    key = {
      region_init.edge_id,
      region_init.scape_id,
      region_init.id,
      region_init.continent,
      region_init.continent_region
    }

    :regions_cache
    |> Cachex.put!(key, region_init)

    notify_regions_updated({@initializing_region_v1, region_init})

    {:noreply, state}
  end

  ################### INTERNALS ###################

  defp notify_regions_updated(cause) do
    PubSub.broadcast!(
      Swai.PubSub,
      @regions_cache_updated_v1,
      cause
    )
  end

  ################## PLUMBING ##################
  def child_spec(opts),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker
    }

  def start_link(opts \\ []),
    do:
      GenServer.start_link(
        __MODULE__,
        opts,
        name: __MODULE__
      )
end

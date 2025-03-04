defmodule Swarms.Service do
  @moduledoc """
  The service wrapper module for the swarms cache.
  """
  use GenServer

  require Colors
  require Logger

  alias Schema.Swarm, as: Swarm
  alias Phoenix.PubSub, as: PubSub

  #################### API ####################
  def get_swarm(license_id),
    do:
      GenServer.call(
        __MODULE__,
        {:get_swarm, license_id}
      )

  def add_swarm(%Swarm{} = swarm),
    do:
      GenServer.cast(
        __MODULE__,
        {:add_swarm, swarm}
      )

  #################### INIT ####################
  @impl true
  def init(_args) do
    Logger.debug("Starting Swarms service #{Colors.swarm_theme(self())}")
    {:ok, %{}}
  end

  ################## add_swarm ##################
  @impl true
  def handle_cast({:add_swarm, swarm}, state) do
    :swarms_cache
    |> Cachex.put!(swarm.id, swarm)

    {:noreply, state}
  end

  ################### get_swarm ###################
  @impl true
  def handle_call({:get_swarm, license_id}, _from, state) do

    {
      :reply,
      :particles_cache
      |> Cachex.get!(license_id),
      state
    }
  end

  #################### PLUMBING ####################
  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker
    }
  end

  def start_link(_args) do
    GenServer.start_link(
      __MODULE__,
      %{},
      name: __MODULE__
    )
  end
end

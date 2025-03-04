defmodule Particle.AIWorker do
  @moduledoc """
  This module is responsible for managing the particles in the system.
  """
  use GenServer

  alias Swai.Registry, as: SwaiRegistry
  alias Swai.Defaults, as: Limits

  @particle_heartbeat Limits.particle_heartbeat()

  require Logger
  require Colors

  def start(state) do
    case start_link(state) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start #{__MODULE__}: #{inspect(reason, pretty: true)}")
        {:error, reason}
    end
  end

  ################## INIT  ##################
  @impl true
  def init(%{id: particle_id} = state) do
    Process.flag(:trap_exit, true)
    Process.send_after(self(), :tick, @particle_heartbeat)

    Logger.debug("#{__MODULE__} is up: #{Colors.particle_theme(self())} id: #{particle_id}")
    {:ok, state}
  end

  @impl true
  def handle_info(:tick, state) do
    Process.send_after(self(), :tick, @particle_heartbeat)
    {:noreply, state}
  end

  ################### PLUMBING ###################
  def to_name(particle_id),
    do: "#{__MODULE__}.#{particle_id}"

  def via(key),
    do: SwaiRegistry.via_tuple({__MODULE__, to_name(key)})

  def via_sup(key),
    do: SwaiRegistry.via_tuple({:particle_sup, to_name(key)})

  def child_spec(%{id: particle_id} = state),
    do: %{
      id: to_name(particle_id),
      start: {__MODULE__, :start, [state]},
      type: :worker,
      restart: :transient
    }

  def start_link(%{id: particle_id} = state),
    do:
      GenServer.start_link(
        __MODULE__,
        state,
        name: via(particle_id)
      )
end

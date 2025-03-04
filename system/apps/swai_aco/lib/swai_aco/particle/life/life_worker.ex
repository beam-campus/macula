defmodule Particle.LifeWorker do
  @moduledoc """
  This module is responsible for managing the life of the particles in the system.
  """
  use GenServer

  alias Swai.Registry, as: SwaiRegistry

  require Logger
  require Colors

  ########## PLUMBING   ##########

  def to_name(key),
    do: "#{__MODULE__}:#{key}"

  def via(key),
    do: SwaiRegistry.via_tuple({__MODULE__, to_name(key)})

  def start(state) do
    case start_link(state) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start #{__MODULE__}: #{reason}")
        {:error, reason}
    end
  end

  @impl true
  def init(state) do
    Logger.debug("#{__MODULE__} is up => #{Colors.particle_life_worker_theme(self())}")
    {:ok, state}
  end

  def start_link(%{id: particle_id} = state),
    do:
      GenServer.start_link(
        __MODULE__,
        state,
        name: via(particle_id)
      )

  def child_spec(%{id: particle_id} = state) do
    %{
      id: via(particle_id),
      start: {__MODULE__, :start, [state]},
      type: :worker,
      restart: :transient
    }
  end
end

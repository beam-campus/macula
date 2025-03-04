defmodule SwaiAco.Particle.PheromoneSensor do
  @moduledoc """
  This module is responsible for dropping pheromones in the system.
  """
  use GenServer

  alias Particle.Init, as: ParticleInit
  alias Swai.Registry, as: SwaiRegistry
  alias SwaiAco.Particle.System, as: ParticleSystem
  alias SwaiAco.Particle.AIWorker, as: ParticleBrain

  require Logger
  require Colors

  def start(particle_init) do
    case start_link(particle_init) do
      {:ok, pid} ->
        Logger.debug("Started [#{__MODULE__} > #{inspect(pid)}]]")
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.warning("Already Started [#{__MODULE__} > #{inspect(pid)}]]")
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start #{__MODULE__}: #{reason}")
        {:error, reason}
    end
  end

  ################## INIT  ##################
  @impl true
  def init(%ParticleInit{} = particle_init) do
    Process.flag(:trap_exit, true)
    Process.send_after(self(), :tick, 1_000)

    Logger.debug("#{__MODULE__} is up: #{Colors.particle_theme(self())} id: #{particle_init.id}")
    {:ok, particle_init}
  end

  @impl true
  def handle_info(:tick, state) do
    Logger.debug("TICK: #{inspect(self())}")

    Process.send_after(self(), :tick, 1_000)
    {:noreply, state}
  end

  ################### PLUMBING ###################
  def to_name(particle_id),
    do: "#{__MODULE__}.#{particle_id}"


  def via(key),
    do: SwaiRegistry.via_tuple({__MODULE__, to_name(key)})


  def child_spec(%{id: particle_id} = particle_init) do
    %{
      id: to_name(particle_id),
      start: {__MODULE__, :start, [particle_init]},
      type: :worker,
      restart: :transient
    }
  end


  def start_link(%{id: particle_id} = particle_init),
    do:
      GenServer.start_link(
        __MODULE__,
        particle_init,
        name: via(particle_id)
      )
end

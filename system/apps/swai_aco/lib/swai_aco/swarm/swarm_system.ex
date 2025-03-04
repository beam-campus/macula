defmodule SwaiAco.Swarm.System do
  @moduledoc """
  This module is responsible for managing the particles in the system.
  """
  use GenServer

  alias Particle.Init, as: ParticleInit
  alias Swai.Registry, as: SwaiRegistry
  alias SwaiAco.Settings, as: Settings

  require Logger
  require Colors

  @freq_hz Settings.model_frequency_hz

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


  @impl true
  def init(%ParticleInit{} = particle_init) do
    Process.flag(:trap_exit, true)





    Process.send_after(self(), :tick, round(1_000 / @freq_hz))
    Logger.debug("#{__MODULE__} is up: #{Colors.particle_theme(self())} id: #{particle_init.id}")
    {:ok, particle_init}
  end





  @impl true
  def handle_info(:tick, state) do
    Logger.debug("TICK: #{inspect(self())}")



    Process.send_after(self(), :tick, round(1_000 / @freq_hz))
    {:noreply, state}
  end


  ################### PLUMBING ###################
  def to_name(particle_id),
    do: "#{__MODULE__}.#{particle_id}"

  def via(key),
    do: SwaiRegistry.via_tuple({__MODULE__, to_name(key)})

  def via_sup(key),
    do: SwaiRegistry.via_tuple({:particle_sup, to_name(key)})

  def child_spec(%{id: particle_id} = particle_init) do
    %{
      id: to_name(particle_id),
      start: {__MODULE__, :start, [particle_init]},
      type: :supervisor,
      restart: :transient
    }
  end

  def which_children(particle_id) do
    Supervisor.which_children(via_sup(particle_id))
  end

  def start_link(%{id: particle_id} = particle_init),
    do:
      GenServer.start_link(
        __MODULE__,
        particle_init,
        name: via(particle_id)
      )
end

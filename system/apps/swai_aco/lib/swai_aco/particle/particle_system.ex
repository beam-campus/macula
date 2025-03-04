defmodule Particle.System do
  @moduledoc """
  This module is responsible for managing the particles in the system.
  """
  use GenServer

  alias ErlUtils, as: ErlUtils
  alias Particle.Init, as: ParticleInit
  alias Particle.Emitter, as: ParticleEmitter
  alias Swai.Registry, as: SwaiRegistry
  alias Swai.Defaults, as: Limits
  alias Phoenix.PubSub, as: PubSub
  alias Particle.Facts, as: ParticleFacts

  require Logger
  require Colors

  @particle_facts ParticleFacts.particle_facts()
  @particle_moved_v1 {:particle, ParticleFacts.particle_moved_v1()}
  @heart_beat Limits.particle_heartbeat()

  ################### INTERNALS ##################


   

  defp do_age(%ParticleInit{particle_id: particle_id, age: age, ticks: ticks} = particle) do
    new_age =
      if rem(ticks, Limits.particle_heartbeats_per_age()) == 0 do
        age + 1
      else
        age
      end
      
    %ParticleInit{
      particle
      | age: new_age,
        ticks: ticks + 1
    }
  end

  defp must_die?(%ParticleInit{age: age, health: health, energy: energy}),
    do: age > Limits.particle_max_age() or health <= 0 or energy <= 0

  ###################### API ######################
  def get_particle(particle_id),
    do:
      GenServer.call(
        via(particle_id),
        :get_particle
      )

  def start(particle_init) do
    case start_link(particle_init) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start #{__MODULE__}: #{inspect(reason, pretty: true)}")
        {:error, reason}
    end
  end

  ###################### INIT ######################
  @impl true
  def init(%ParticleInit{particle_id: particle_id, hive_id: hive_id} = particle) do
    Process.flag(:trap_exit, true)

    sub_systems = [
      {Particle.MoveActuator, particle},
      {Particle.AIWorker, %{id: particle_id}}
    ]

    case Supervisor.start_link(
           sub_systems,
           name: via_sup(particle_id),
           strategy: :one_for_one
         ) do
      {:ok, _} ->
        :edge_pubsub
        |> PubSub.subscribe(@particle_facts)

        Logger.debug("SPAWNED: Particle [#{particle_id}] in Hive [#{hive_id}]")        
        Logger.debug("#{__MODULE__} is up => #{Colors.particle_theme(self())}")
        ParticleEmitter.emit_particle_spawned(particle)
        Process.send_after(self(), :HEART_BEAT, @heart_beat)
        {:ok, particle}

      {:error, reason} ->
        Logger.error(
          "Failed to start #{__MODULE__} for Particle :[#{particle_id}]:Reason: #{inspect(reason, pretty: true)}"
        )

        {:stop, reason}
    end
  end

  ######################## HEARTBEAT ######################
  @impl true
  def handle_info(:HEART_BEAT, %{particle_id: particle_id} = particle) do
    if must_die?(particle) do
      Logger.alert("[#{particle_id}] DIED!")
      ParticleEmitter.emit_particle_died(particle)
      SwaiRegistry.unregister(via(particle_id))
      SwaiRegistry.unregister(via_sup(particle_id))
      {:stop, :normal, particle}
    else
      Process.send_after(self(), :HEART_BEAT, @heart_beat)
      {:noreply, particle |> do_age()}
    end
  end

  ################ MOVED ######################
  @impl true
  def handle_info({@particle_moved_v1, movememt}, particle) do
    new_particle =
      case ParticleInit.from_map(particle, movememt) do
        {:ok, new_particle} ->
          new_particle

        {:error, changeset} ->
          Logger.error("Invalid movement: #{inspect(changeset, pretty: true)}")
          particle
      end

    {:noreply, new_particle}
  end

  ###################### GET PARTICLE ##################
  @impl true
  def handle_call(:get_particle, _from, particle),
    do: {:reply, particle, particle}

  ###################### PLUMBING ######################
  def to_name(particle_id),
    do: "particle.system:#{particle_id}"

  def via(key),
    do: SwaiRegistry.via_tuple({__MODULE__, to_name(key)})

  def via_sup(key),
    do: SwaiRegistry.via_tuple({:particle_sup, to_name(key)})

  def child_spec(%ParticleInit{particle_id: part_id} = particle),
    do: %{
      id: to_name(part_id),
      start: {__MODULE__, :start, [particle]},
      type: :supervisor,
      restart: :temporary
    }

  def which_children(part_id),
    do: Supervisor.which_children(via_sup(part_id))

  def start_link(%ParticleInit{particle_id: part_id} = particle),
    do:
      GenServer.start_link(
        __MODULE__,
        particle,
        name: via(part_id)
      )
end

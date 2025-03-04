defmodule Particles.Service do
  @moduledoc """
  The ParticlesService is a GenServer that manages the particles cache.
  """
  use GenServer

  require Logger

  alias Particle.Facts, as: ParticleFacts
  alias Phoenix.PubSub, as: PubSub

  @particle_facts ParticleFacts.particle_facts()
  @particles_cache_facts ParticleFacts.particles_cache_facts()
  @particle_spawned_v1 ParticleFacts.particle_spawned_v1()
  @particle_changed_v1 ParticleFacts.particle_changed_v1()
  @particle_died_v1 ParticleFacts.particle_died_v1()

  def start(args) do
    case start_link(args) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Particles.Service failed to start: #{reason}")
        {:error, reason}
    end
  end

  def get_all() do
    GenServer.call(
      __MODULE__,
      :get_all
    )
  end

  def get_for_scape!(nil), do: []

  def get_for_scape!(scape_id) do
    GenServer.call(
      __MODULE__,
      {:get_for_scape, scape_id}
    )
  end

  def get_swarm(license_id) do
    GenServer.call(
      __MODULE__,
      {:get_swarm, license_id}
    )
  end

  @impl GenServer
  def handle_call(:get_all, _from, state) do
    particles =
      :particles_cache
      |> Cachex.stream!()
      |> Stream.map(fn {:entry, _, _, _, particle} -> particle end)
      |> Enum.to_list()

    {:reply, particles, state}
  end

  @impl GenServer
  def handle_call({:get_swarm, license_id}, _from, state) do
    swarm =
      :particles_cache
      |> Cachex.stream!()
      |> Stream.filter(fn {:entry, _, _, _, particle} -> particle.license_id == license_id end)
      |> Stream.map(fn {:entry, _, _, _, particle} -> particle end)
      |> Enum.to_list()

    {:reply, swarm, state}
  end

  @impl GenServer
  def handle_call({:get_for_scape, scape_id}, _from, state) do
    particles =
      :particles_cache
      |> Cachex.stream!()
      |> Stream.filter(fn {:entry, _, _, _, particle} -> particle.scape_id == scape_id end)
      |> Stream.map(fn {:entry, _, _, _, particle} -> particle end)
      |> Enum.to_list()

    {:reply, particles, state}
  end

  ################ SUBSCRIPTIONS ################
  @impl GenServer
  def handle_info(
        {
          :particle,
          @particle_spawned_v1,
          %{particle_id: particle_id} = particle
        } = cause,
        state
      ) do
    :particles_cache
    |> Cachex.put!(particle_id, particle)

    do_notify_particles_cache_changed(cause)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(
        {
          :particle,
          @particle_changed_v1,
          %{particle_id: particle_id} = particle
        } = cause,
        state
      ) do
    :particles_cache
    |> Cachex.put!(particle_id, particle)

    do_notify_particles_cache_changed(cause)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(
        {
          :particle,
          @particle_died_v1,
          %{particle_id: particle_id}
        } = cause,
        state
      ) do
    :particles_cache
    |> Cachex.del!(particle_id)

    do_notify_particles_cache_changed(cause)

    {:noreply, state}
  end

  defp do_notify_particles_cache_changed(cause),
    do:
      Swai.PubSub
      |> PubSub.broadcast(@particles_cache_facts, {:particles, cause})

  #################### PLUMBING ####################
  @impl GenServer
  def init(args) do
    Logger.debug("Starting Particles service")

    Swai.PubSub
    |> PubSub.subscribe(@particle_facts)

    {:ok, args}
  end

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start, [args]},
      restart: :permanent
    }
  end

  def start_link(args) do
    GenServer.start_link(
      __MODULE__,
      args,
      name: __MODULE__
    )
  end
end

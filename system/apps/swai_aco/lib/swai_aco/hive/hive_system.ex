defmodule Hive.System do
  @moduledoc """
  This module is responsible for managing the particles in the system.
  """
  use GenServer

  alias Particle.System, as: ParticleSystem
  alias Hive.Emitter, as: HiveEmitter
  alias Hive.Init, as: HiveInit
  alias Hive.Status, as: HiveStatus
  alias Particle.Init, as: Particle
  # alias Arena.Hexa, as: Hexa
  alias Swai.Defaults, as: Limits

  alias Swai.Registry, as: SwaiRegistry

  require Logger
  require Colors

  @hive_status_vacant HiveStatus.hive_vacant()
  @hive_status_occupied HiveStatus.hive_occupied()
  @hive_cycle Limits.hive_cycle()
  @initial_claim_delay Limits.initial_claim_delay()
  @normal_claim_delay Limits.normal_claim_delay()
  @start_swarm_delay Limits.start_swarm_delay()

  # @arena_hexa_size Limits.arena_hexa_size()

  ## Get the swarm of particles
  def get_particles(hive_id) do
    which_children(hive_id)
  end

  ## Count the number of particles
  def count_particles(hive_id) do
    %{active: count} = Supervisor.count_children(via_sup(hive_id))
    count
  end

  #################### START  ####################
  def start(hive_init) do
    case start_link(hive_init) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start hive.system: #{inspect(reason)}")
        {:error, reason}
    end
  end

  #################### INIT ####################
  @impl true
  def init(
        %HiveInit{
          scape_name: scape_name,
          hive_no: hive_no,
          hive_id: hive_id
        } = hive_init
      ) do
    Process.flag(:trap_exit, true)

    case Supervisor.start_link(
           [],
           name: via_sup(hive_id),
           strategy: :one_for_one
         ) do
      {:ok, _} ->
        HiveEmitter.emit_hive_initialized(hive_init)
        Process.send_after(self(), :CLAIM_LICENSE, @initial_claim_delay)
        Logger.debug("hive[#{scape_name}][#{hive_no}] is up => #{Colors.particle_theme(self())}")
        {:ok, hive_init}

      {:error, reason} ->
        Logger.error("Failed to start Hive subsystems: #{inspect(reason, pretty: true)}")
        {:stop, reason}
    end
  end

  #################### HANDLE CAST ####################
  ## Handle Cast Fallthrough
  @impl true
  def handle_cast(_, state) do
    {:noreply, state}
  end

  #################### SPAWN PARTICLE ####################
  defp do_spawn_particle(%{hive_id: hive_id} = hive) do
    particle_id = "pt-#{UUID.uuid4()}"
    seed = %Particle{particle_id: particle_id}

    particle_init =
      case Particle.from_map(seed, hive) do
        {:ok, particle} ->
          particle

        {:error, changeset} ->
          Logger.error("Invalid Hive: #{inspect(changeset, pretty: true)}")
          seed
      end

    particle =
      %Particle{
        particle_init
        | hive_hexa: particle_init.hexa
      }

    Supervisor.start_child(
      via_sup(hive_id),
      {ParticleSystem, particle}
    )

    hive
  end

  defp do_vacate_hive(hive) do
    hive =
      %HiveInit{
        hive
        | hive_status: @hive_status_vacant,
          user_id: nil,
          user_alias: nil,
          license_id: nil,
          license: nil
      }

    HiveEmitter.emit_hive_vacated(hive)
    hive
  end

  ################### LIVE! ##############################
  @impl true
  def handle_info(
        :LIVE,
        %HiveInit{
          hive_id: hive_id,
          particles_cap: particles_cap,
          hive_status: @hive_status_occupied
        } = hive
      ) do
    new_hive =
      cond do
        count_particles(hive_id) == 0 ->
          Process.send_after(self(), :CLAIM_LICENSE, @normal_claim_delay)
          do_vacate_hive(hive)

        count_particles(hive_id) < particles_cap ->
          Process.send_after(self(), :LIVE, @hive_cycle)
          do_spawn_particle(hive)
          hive

        true ->
          Process.send_after(self(), :LIVE, @hive_cycle)
          hive
      end

    {:noreply, new_hive}
  end

  ##################### CLAIM LICENSE ######################
  @impl true
  def handle_info(
        :CLAIM_LICENSE,
        %HiveInit{
          hive_id: hive_id,
          scape_id: scape_id,
          scape_name: scape_name,
          license: nil,
          hive_status: @hive_status_vacant
        } = hive
      ) do
    case HiveEmitter.try_reserve_license(hive) do
      nil ->
        Process.send_after(self(), :CLAIM_LICENSE, @normal_claim_delay)
        {:noreply, hive}

      %{
        license_id: license_id,
        user_id: user_id,
        user_alias: user_alias
      } = license ->
        Logger.warning(
          "License [#{license_id}] for user [#{user_alias}]  assigned to Hive [#{hive_id}] => #{Colors.hive_theme(self())}"
        )

        new_hive =
          %HiveInit{
            hive
            | license: license,
              scape_id: scape_id,
              scape_name: scape_name,
              user_id: user_id,
              user_alias: user_alias,
              license_id: license_id,
              hive_status: @hive_status_occupied
          }

        HiveEmitter.emit_hive_occupied(new_hive)
        Process.send_after(self(), :START_SWARM, @start_swarm_delay)
        {:noreply, new_hive}
    end
  end

  ##################### START SWARM ######################
  @impl true
  def handle_info(:START_SWARM, %{hive_id: hive_id, user_alias: user_alias} = hive) do
    Logger.alert("Starting Swarm in Hive [#{hive_id}] for user [#{user_alias}]")

    new_hive =
      do_spawn_particle(hive)

    Process.send_after(self(), :LIVE, @hive_cycle)
    {:noreply, new_hive}
  end

  ################### PLUMBING ###################
  @impl true
  def terminate(reason, %HiveInit{hive_no: hive_no, scape_name: scape_name} = hive) do
    Logger.debug("Hive [#{scape_name}][#{hive_no}] terminated. #{inspect(reason, pretty: true)}")
    HiveEmitter.emit_hive_detached(hive)
    :ok
  end

  def to_name(key),
    do: "#{__MODULE__}:#{key}"

  def via(key),
    do: SwaiRegistry.via_tuple({:hive_sys, to_name(key)})

  def via_sup(key),
    do: SwaiRegistry.via_tuple({:hive_sup, to_name(key)})

  def child_spec(%{hive_id: hive_id} = hive_init) do
    %{
      id: to_name(hive_id),
      start: {__MODULE__, :start, [hive_init]},
      type: :supervisor,
      restart: :transient
    }
  end

  def which_children(hive_id) do
    Supervisor.which_children(via_sup(hive_id))
  end

  def start_link(%{hive_id: hive_id} = hive_init),
    do:
      GenServer.start_link(
        __MODULE__,
        hive_init,
        name: via(hive_id)
      )
end

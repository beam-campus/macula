defmodule Particle.MoveActuator do
  @moduledoc """
  This module is responsible for moving particles in the system.
  """
  use GenServer

  alias Swai.Registry, as: SwaiRegistry
  alias Arena.System, as: ArenaSystem
  alias Phoenix.PubSub, as: PubSub
  alias Swai.Defaults, as: Defaults
  alias Arena.Hexa, as: Hexa
  alias Particle.Facts, as: ParticleFacts
  alias Particle.Init, as: ParticleInit
  alias Schema.Vector, as: Vector

  require Logger
  require Colors

  @auto_move true
  @move_every Defaults.move_every()
  @particle_facts ParticleFacts.particle_facts()
  @particle_moved_v1 {:particle, ParticleFacts.particle_moved_v1()}

  ################## PUBLIC ##################
  def start(particle) do
    case start_link(particle) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start #{__MODULE__}: #{inspect(reason, pretty: true)}")
        {:error, reason}
    end
  end

  def move(particle_id, scape_id, direction, from, speed),
    do:
      GenServer.cast(
        via(particle_id),
        {:MOVE, scape_id, direction, from, speed}
      )

  defp do_random_number(a, b),
    do: :rand.uniform(b - a + 1) + a - 1

  defp do_maybe_change_orientation(orientation) do
    if rem(do_random_number(11, 1_000), :rand.uniform(10)) == 0 do
      Defaults.hexa_directions()
      |> Map.keys()
      |> Enum.random()
    else
      orientation
    end
  end

  defp do_change_hexa(%{q: q, r: r}, orientation, momentum) do
    {dq, dr} = Defaults.hexa_directions()[orientation]

    %Hexa{
      q: q + dq * momentum,
      r: r + dr * momentum
    }
  end

  defp do_calculate_position(%{q: q, r: r}) do
    cart = Hexa.axial_to_cartesian(%{q: q, r: r}, Defaults.arena_hexa_size())

    raw =
      case Vector.from_map(%Vector{}, cart) do
        {:ok, vector} ->
          vector

        {:error, changeset} ->
          Logger.error("Invalid vector: #{inspect(changeset, pretty: true)}")
          %Vector{x: 0.0, y: 0.0, z: 0.0}
      end

    %Vector{
      raw
      | x: :math.floor(raw.x),
        y: :math.floor(raw.y),
        z: 0
    }
  end

  defp do_move(particle_id, scape_id, orientation, hexa, momentum) do
    new_hexa =
      do_change_hexa(hexa, orientation, momentum)

    if ArenaSystem.allow_move?(scape_id, hexa, new_hexa) do
      particle_moved =
        %{
          scape_id: scape_id,
          particle_id: particle_id,
          orientation: orientation,
          hexa: new_hexa,
          momentum: momentum,
          position: do_calculate_position(new_hexa)
        }

      :edge_pubsub
      |> PubSub.broadcast!(@particle_facts, {@particle_moved_v1, particle_moved})


    end
  end

  ################## MOVE ##################
  @impl true
  def handle_cast({:MOVE, scape_id, direction, from, speed}, particle_id) do
    do_move(particle_id, scape_id, direction, from, speed)

    {:noreply, particle_id}
  end

  ################## INIT  ##################
  @impl true
  def init(state) do
    Process.send_after(self(), :LIVE, @move_every)

    :edge_pubsub
    |> PubSub.subscribe(@particle_facts)
    
    Logger.debug("#{__MODULE__} is UP => #{Colors.particle_theme(self())}")

    {:ok, state}
  end

  @impl true
  def handle_info(
        {@particle_moved_v1, %{particle_id: particle_id} = movement},
        %{particle_id: my_id} = state
      )
      when particle_id == my_id do
    new_state =
      case ParticleInit.from_map(state, movement) do
        {:ok, new_state} ->
          new_state

        {:error, changeset} ->
          Logger.error("Invalid movment: 
            #{inspect(changeset, pretty: true)}
            ")
          state
      end

    {:noreply, new_state}
  end

  @impl true
  def handle_info(
        :LIVE,
        %{
          particle_id: particle_id,
          scape_id: scape_id,
          hexa: from,
          momentum: speed,
          orientation: orientation
        } = state
      ) do
    if @auto_move do
      new_orientation =
        do_maybe_change_orientation(orientation)

      do_move(particle_id, scape_id, new_orientation, from, speed)
    end

    Process.send_after(self(), :LIVE, @move_every)
    {:noreply, state}
  end

  @impl true
  def handle_info(_, state) do
    {:noreply, state}
  end

  ################### PLUMBING ###################
  def to_name(particle_id),
    do: "move.actuator:#{particle_id}"

  def via(key),
    do: SwaiRegistry.via_tuple({__MODULE__, to_name(key)})

  def child_spec(%{particle_id: particle_id} = particle) do
    %{
      id: to_name(particle_id),
      start: {__MODULE__, :start, [particle]},
      type: :worker,
      restart: :transient
    }
  end

  def start_link(%{particle_id: particle_id} = particle),
    do:
      GenServer.start_link(
        __MODULE__,
        particle,
        name: via(particle_id)
      )
end

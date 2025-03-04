defmodule Arena.System do
  @moduledoc """
  This module is responsible for managing the particles in the system.
  """
  use GenServer

  alias Swai.Registry, as: SwaiRegistry
  alias SwaiAco.Settings, as: Settings
  alias Arena.Init, as: ArenaInit
  alias Arena.Emitter, as: ArenaEmitter

  require Logger
  require Colors

  @freq_hz Settings.model_frequency_hz()

  def allow_move?(scape_id, from, to),
    do:
      GenServer.call(
        via(scape_id),
        {:allow_move?, %{from: from, to: to}}
      )

  def get_max_hexa(scape_id),
    do:
      GenServer.call(
        via(scape_id),
        {:get_max_hexa}
      )

  ####################### START #######################
  def start(arena_init) do
    case start_link(arena_init) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start #{__MODULE__}: #{inspect(reason, pretty: true)}")
        {:error, reason}
    end
  end

  ####################### INIT #######################
  @impl true
  def init(%ArenaInit{scape_name: scape_name} = arena_init) do
    Process.flag(:trap_exit, true)

    Process.send_after(self(), :TICK, round(1_000 / @freq_hz))

    ArenaEmitter.emit_arena_initialized(arena_init)

    Logger.debug("Arena for Scape [#{scape_name}] is up => #{Colors.arena_theme(self())}")

    {:ok, arena_init}
  end

  ############### CALL ALLOW_MOVE? ###############
  @impl true
  def handle_call(
        {:allow_move?, %{to: %{q: tq}}},
        _from,
        %{max_hexa: %{q: max_q}} = state
      )
      when tq >= max_q,
      do: {:reply, false, state}

  @impl true
  def handle_call(
        {:allow_move?, %{to: %{r: tr}}},
        _from,
        %{max_hexa: %{r: max_r}} = state
      )
      when tr >= max_r,
      do: {:reply, false, state}

  @impl true
  def handle_call(
        {:allow_move?, %{to: %{q: tq}}},
        _from,
        state
      )
      when tq <= 0,
      do: {:reply, false, state}

  @impl true
  def handle_call(
        {:allow_move?, %{to: %{r: tr}}},
        _from,
        state
      )
      when tr <= 0,
      do: {:reply, false, state}

  @impl true
  def handle_call(
        {:allow_move?, %{to: %{q: _tq, r: _tr}}},
        _from,
        %{max_hexa: %{q: _max_q, r: _max_r}} = state
      ),
      do: {:reply, true, state}

  #################### CALL MAX_HEXA ####################
  @impl true
  def handle_call(:get_max_hexa, _from, %ArenaInit{max_hexa: max_hexa} = arena),
    do: {:reply, max_hexa, arena}

  ####################### HEARTBEAT #######################
  @impl true
  def handle_info(:TICK, state) do
    Process.send_after(self(), :TICK, round(1_000 / @freq_hz))
    {:noreply, state}
  end

  ####################### UNHANDLED INFO #######################
  @impl true
  def handle_info(_, state) do
    {:noreply, state}
  end

  ################### PLUMBING ###################
  def to_name(key),
    do: "#{__MODULE__}:#{key}"

  def via(key),
    do: SwaiRegistry.via_tuple({:arena, to_name(key)})

  def via_sup(key),
    do: SwaiRegistry.via_tuple({:arena_sup, to_name(key)})

  def child_spec(%ArenaInit{scape_id: scape_id} = arena_init) do
    %{
      id: to_name(scape_id),
      start: {__MODULE__, :start, [arena_init]},
      type: :supervisor,
      restart: :transient
    }
  end

  def which_children(scape_id) do
    Supervisor.which_children(via_sup(scape_id))
  end

  def start_link(%ArenaInit{scape_id: scape_id} = arena_init),
    do:
      GenServer.start_link(
        __MODULE__,
        arena_init,
        name: via(scape_id)
      )
end

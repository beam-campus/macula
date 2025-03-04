defmodule Scape.System do
  @moduledoc """
  Scape.System is the top-level supervisor for the Swai.MngScape subsystem.
  """
  use GenServer

  require Logger
  require Colors
  require Process
  require Task

  alias Arena.Init, as: ArenaInit

  alias Hive.Init, as: HiveInit

  alias Scape.Emitter, as: ScapeEmitter
  alias Scape.Init, as: ScapeInit
  #  alias Macula.Ringcaster, as: Ringcaster

  ################# START HIVE #####################
  defp start_hives(%{hives_cap: hives_cap, scape_id: scape_id}) do
    1..hives_cap
    |> Enum.each(fn hive_no ->
      GenServer.cast(
        via(scape_id),
        {:start_hive, hive_no}
      )
    end)
  end

  ################# INIT #####################
  @impl GenServer
  def init(
        %ScapeInit{
          scape_id: scape_id
        } = scape_init
      ) do
    Process.flag(:trap_exit, true)
    ScapeEmitter.emit_initializing_scape(scape_init)

    start_hives =
      Task.async(fn ->
        start_hives(scape_init)
      end)

    {:ok, arena_init} =
      ArenaInit.new(scape_init)

    case Supervisor.start_link(
           [
        #             {Ringcaster, scape_init},
             {Arena.System, arena_init}
           ],
           strategy: :one_for_one,
           name: via_sup(scape_id)
         ) do
      {:ok, _pid} ->
        Task.await(start_hives)
        {:ok, scape_init}

      {:error, reason} ->
        Logger.error("Failed to start Scape.System: #{inspect(reason, pretty: true)}")
        {:stop, reason}
    end

    ScapeEmitter.emit_scape_initialized(scape_init)
    Logger.debug("scape.system is up: #{Colors.scape_theme(self())}")
    {:ok, scape_init}
  end

  ################## START #####################
  def start(scape_init) do
    case start_link(scape_init) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start #{__MODULE__}: #{inspect(reason, pretty: true)}")
        {:error, reason}
    end
  end

  @doc """
  Returns the list of children supervised by this module
  """
  def which_children(scape_id),
    do:
      Supervisor.which_children(via_sup(scape_id))
      |> Enum.reverse()

  ################ HANDLE START HIVE  ##########################
  @impl GenServer
  def handle_cast({:start_hive, hive_no}, %ScapeInit{scape_id: scape_id} = scape_init) do
    {:ok, hive_init} =
      HiveInit.new(hive_no, scape_init)

    Supervisor.start_child(
      via_sup(scape_id),
      {Hive.System, hive_init}
    )

    {:noreply, scape_init}
  end

  ##################### HANDLE EXIT ############################
  @impl GenServer
  def handle_info(
        {:EXIT, from_pid, reason},
        %ScapeInit{} = scape_init
      ) do
    Logger.info(
      "#{Colors.red_on_black()}EXIT received from #{inspect(from_pid)} reason: #{inspect(reason, pretty: true)}#{Colors.reset()}"
    )

    {:noreply, scape_init}
  end

  ##################### HANDLE INFO FALLTHROUGH ############################
  @impl GenServer
  def handle_info(msg, state) do
    Logger.warning("Unhandled Info: [#{msg}]")
    {:noreply, state}
  end

  ##################### TERMINATE ############################
  @impl GenServer
  def terminate(reason, scape_init) do
    Logger.warning(
      "#{Colors.red_on_black()}Terminating Scape.System with reason: #{inspect(reason, pretty: true)}#{Colors.reset()}"
    )

    ScapeEmitter.emit_scape_detached(scape_init)
    {:ok, scape_init}
  end

  ##################### PLUMBIMG ############################
  def via(key),
    do: Swai.Registry.via_tuple({:scape_sys, to_name(key)})

  def via_sup(key),
    do: Swai.Registry.via_tuple({:scape_sup, to_name(key)})

  def to_name(key) when is_bitstring(key),
    do: "scape.system:#{key}"

  def child_spec(%ScapeInit{scape_id: scape_id} = scape_init),
    do: %{
      id: to_name(scape_id),
      start: {__MODULE__, :start, [scape_init]},
      type: :supervisor,
      restart: :transient,
      shutdown: 500
    }

  def start_link(%ScapeInit{scape_id: scape_id} = scape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        scape_init,
        name: via(scape_id)
      )
end

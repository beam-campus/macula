defmodule Swai.DbSystem do
  use GenServer

  @moduledoc """
  Swai.MngFarms.System is a GenServer that manages the MngFarms cache system.
  """


  require Colors
  require Logger
  require Cachex



  ############# API ################
  def start() do
    case start_link() do
      {:ok, pid} ->
        Logger.info("Swai.DbSystem started => #{Colors.cell_theme(pid)}")
        :ok

      {:error, reason} ->
        Logger.error("Swai.DbSystem failed to start: #{inspect(reason)}")
        {:error, reason}
    end
  end



  ################## CALLBACKS ############
  @impl GenServer
  def init(opts) do


    children = [
      Licenses.Db
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: :caches_system_supervisor
    )

    {:ok, opts}
  end



  ############### PLUMBING ################
  def child_spec(opts),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      restart: :permanent
    }

  def start_link(opts  \\ []),
    do:
      GenServer.start_link(
        __MODULE__,
        opts,
        name: __MODULE__
      )
end

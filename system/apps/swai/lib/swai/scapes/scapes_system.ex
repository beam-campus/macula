defmodule Service.Scapes.System do
  use GenServer

  @moduledoc """
  Service.Scapes.System contains the GenServer for the System.
  """
  ################ CALLBACKS ################
  @impl GenServer
  def terminate(_reason, _state) do
    :ok
  end

  @impl GenServer
  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end

  @impl GenServer
  def init(init_args) do
    Supervisor.start_link(
      [
        Scapes.Service
      ],
      strategy: :one_for_one,
      name: :scapes_system_sup
    )

    {:ok, init_args}
  end

  ###################  PLUMBING  ###################
  def start_link() do
    GenServer.start_link(
      __MODULE__,
      [],
      name: __MODULE__
    )
  end

  def child_spec(_init_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent
    }
  end
end

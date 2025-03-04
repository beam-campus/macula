defmodule TrainSwarmProc.PolicySup do
  @moduledoc """
  Supervisor for policies
  """
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    Supervisor.init(
      [
        TrainSwarmProc.Policies
      ],
      strategy: :one_for_one
    )
  end
end

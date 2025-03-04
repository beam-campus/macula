defmodule Swai.TrainSwarm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  use Application, otp_app: :swai_train_swarm

  @moduledoc false
  @impl Application
  def start(_type, _args) do
    children = [
      TrainSwarmProc.CommandedApp,
      TrainSwarmProc.Policies,
      # TrainSwarmProc.ToPostgresDoc.V1,
      TrainSwarmProc.ToPubSubV1
    ]

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: __MODULE__
    )
  end

  def stop() do
    Supervisor.stop(__MODULE__)
  end
end

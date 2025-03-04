defmodule TrainSwarmProc.CommandedApp do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Commanded.Application, otp_app: :swai_train_swarm

  require Logger
  require Colors

  @impl true
  def init(config) do
    Logger.debug("TrainSwarmProc.CommandedApp: has started #{Colors.edge_theme(self())}")
    {:ok, config}
  end

  router(TrainSwarmProc.Router)
end

defmodule TrainSwarmProc.Repl do
  alias TrainSwarmProc.InitializeLicense.EvtV1, as: Initialized
  alias TrainSwarmProc.ConfigureLicense.EvtV1, as: Configured
  alias TrainSwarmProc.InitializeLicense.CmdV1, as: Initialize
  alias TrainSwarmProc.ConfigureLicense.CmdV1, as: Configure
  alias TrainSwarmProc.InitializeLicense.PayloadV1, as: InitializePayload
  alias TrainSwarmProc.CommandedApp, as: TrainSwarmApp

  require Logger
  require UUID

  def try_initialize_swarm do
    payload = InitializePayload.new("some_user_id", "some_biotope_id", "some_biotope_name")
    cmd = %Initialize{agg_id: UUID.uuid4(), payload: payload}
    res = TrainSwarmApp.dispatch(cmd)
    # Logger.debug("Dispatched Initialize Command #{inspect(res)}")
  end
end

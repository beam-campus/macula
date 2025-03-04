defmodule TrainSwarmProc.StartLicense.StartLicenseCmdV1Test do
  @moduledoc false
  use ExUnit.Case

  alias Schema.SwarmLicense.Status, as: Status

  alias TrainSwarmProc.Aggregate, as: Agg
  alias TrainSwarmProc.StartLicense.CmdV1, as: StartLicense
  alias TrainSwarmProc.StartLicense.Evaluator, as: Evaluator
  alias TrainSwarmProc.StartLicense.EvtV1, as: LicenseStarted

  test "handle/2 raises license started event" do
    agg = %Agg{status: %Status{license_reserved: true}}
    cmd = %StartLicense{status: Status.license_reserved()}

    assert {:ok, evt} = Evaluator.handle(agg, cmd)
    assert %LicenseStarted{} = evt
  end
end

defmodule TrainSwarmProc.PauseLicense.Evaluator do
  @moduledoc """
  The evaluator for the PauseLicense process.
  """
  @behaviour Commanded.Commands.Handler

  import Flags

  alias Schema.SwarmLicense.Status, as: LicenseStatus
  alias TrainSwarmProc.PauseLicense.CmdV1, as: PauseLicense
  alias TrainSwarmProc.PauseLicense.EvtV1, as: LicensePaused

  require Logger

  @license_started LicenseStatus.license_started()
  @license_reserved LicenseStatus.license_reserved()
  @license_queued LicenseStatus.license_queued()

  @impl Commanded.Commands.Handler
  def handle(%{status: status} = _agg, %PauseLicense{} = cmd) do
    if status
      |> has_any?([@license_reserved, @license_queued,  @license_started]) do
      Logger.info("PauseLicense: pausing license")
      raise_license_paused(cmd)
    else
      Logger.error("PauseLicense: license not started, reserved or queued")
      {:error, "License not started, reserved or queued"}
    end
  end

  defp raise_license_paused(cmd) do
    case LicensePaused.from_map(%LicensePaused{}, cmd) do
      {:ok, evt} ->
        evt

      {:error, reason} ->
        Logger.error("PauseLicense: invalid Pause License command")
        {:error, reason}
    end
  end
end

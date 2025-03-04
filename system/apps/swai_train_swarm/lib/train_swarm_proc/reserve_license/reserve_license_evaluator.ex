defmodule TrainSwarmProc.ReserveLicense.Evaluator do
  @moduledoc """
  This module is responsible for evaluating the reservation of a license.
  """
  @behaviour Commanded.Commands.Handler

  alias TrainSwarmProc.Aggregate, as: Agg
  alias TrainSwarmProc.ReserveLicense.CmdV1, as: ReserveLicense
  alias TrainSwarmProc.ReserveLicense.EvtV1, as: LicenseReserved

  alias Schema.SwarmLicense.Status, as: Status

  @license_queued Status.license_queued()
  @license_paused Status.license_paused()

  import Flags

  @impl Commanded.Commands.Handler
  def handle(%Agg{status: status}, %ReserveLicense{} = cmd) do
    if status
       |> has_any?([@license_queued, @license_paused]) do
      raise_license_reserved(cmd)
    else
      {:error, "A license must not be queued or paused to reserve it."}
    end
  end

  defp raise_license_reserved(cmd) do
    case LicenseReserved.from_map(%LicenseReserved{}, cmd) do
      {:ok, evt} ->
        evt

      {:error, reason} ->
        {:error, reason}
    end
  end
end

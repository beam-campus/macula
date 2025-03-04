defmodule TrainSwarmProc.PayLicense.Evaluator do
  @moduledoc """
  This module is responsible for evaluating the license of the user.
  """
  @behaviour Commanded.Commands.Handler

  alias TrainSwarmProc.PayLicense.CmdV1, as: PayLicense
  alias TrainSwarmProc.PayLicense.EvtV1, as: LicensePaid

  @impl Commanded.Commands.Handler
  def handle(_agg, %PayLicense{} = cmd) do
    raise_license_paid(cmd)
  end

  defp raise_license_paid(cmd) do
    case LicensePaid.from_map(%LicensePaid{}, cmd) do
      {:ok, evt} ->
        evt

      {:error, reason} ->
        {:error, reason}
    end
  end
end

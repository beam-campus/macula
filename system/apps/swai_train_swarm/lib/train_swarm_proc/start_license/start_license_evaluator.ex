defmodule TrainSwarmProc.StartLicense.Evaluator do
  @moduledoc """
  This module is responsible for evaluating the start of a scape.
  """
  @behaviour Commanded.Commands.Handler

  alias TrainSwarmProc.Aggregate, as: Agg
  alias TrainSwarmProc.StartLicense.CmdV1, as: StartLicense
  alias TrainSwarmProc.StartLicense.EvtV1, as: LicenseStarted

  alias Schema.SwarmLicense.Status, as: Status

  @license_reserved Status.license_reserved()

  import Flags

  @impl Commanded.Commands.Handler
  def handle(
        %Agg{status: status},
        %StartLicense{} = cmd
      ) do
    if status
       |> has?(@license_reserved) do
      raise_license_started(cmd)
    else
      {:error, "A license must be reserved to start it."}
    end
  end

  defp raise_license_started(cmd) do
    case LicenseStarted.from_map(%LicenseStarted{}, cmd) do
      {:ok, evt} ->
        evt

      {:error, reason} ->
        {:error, reason}
    end
  end
end

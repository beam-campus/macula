defmodule TrainSwarmProc.QueueLicense.Evaluator do
  @moduledoc """
  This module is responsible for evaluating the queueing of a license.
  """
  @behaviour Commanded.Commands.Handler

  alias TrainSwarmProc.Aggregate, as: Aggregate
  alias TrainSwarmProc.QueueLicense.CmdV1, as: QueueLicense
  alias TrainSwarmProc.QueueLicense.EvtV1, as: LicenseQueued

  alias Schema.SwarmLicense.Status, as: Status

  @license_active_status Status.license_active()

  @impl Commanded.Commands.Handler
  def handle(
        %Aggregate{} = agg,
        %QueueLicense{} = cmd
      ) do
    if agg.status
       |> Flags.has?(@license_active_status) do
      raise_license_queued(cmd)
    else
      {:error, "License not active"}
    end
  end

  defp raise_license_queued(%QueueLicense{} = cmd) do
    case LicenseQueued.from_map(%LicenseQueued{}, cmd) do
      {:ok, evt} ->
        evt

      {:error, reason} ->
        {:error, reason}
    end
  end
end

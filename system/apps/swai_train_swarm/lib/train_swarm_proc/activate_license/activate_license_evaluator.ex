defmodule TrainSwarmProc.ActivateLicense.Evaluator do
  @moduledoc """
  Commanded handler for activating the swarm training process.
  """
  @behaviour Commanded.Commands.Handler

  import Flags

  require Logger

  alias Schema.SwarmLicense.Status, as: Status
  alias TrainSwarmProc.Aggregate, as: Agg
  ########################### ACTIVATE LICENSE ###########################
  alias TrainSwarmProc.ActivateLicense.CmdV1, as: ActivateLicense
  alias TrainSwarmProc.ActivateLicense.EvtV1, as: LicenseActivated

  @impl Commanded.Commands.Handler
  def handle(%Agg{status: status} = _agg, %ActivateLicense{} = cmd) do
    cond do
      status
      |> has?(Status.license_active()) ->
        Logger.error("already activated => #{inspect(cmd)}")
        {:error, :already_activated}

      status
      |> has?(Status.license_blocked()) ->
        Logger.error("license blocked => #{inspect(cmd)}")
        {:error, :license_blocked}

      true ->
        raise_activated(cmd)
    end
  end

  defp raise_activated(cmd) do
    case LicenseActivated.from_map(%LicenseActivated{}, cmd) do
      {:ok, evt} ->
        evt

      {:error, reason} ->
        Logger.error("invalid activation command => #{inspect(cmd)}")
        {:error, reason}
    end
  end
end

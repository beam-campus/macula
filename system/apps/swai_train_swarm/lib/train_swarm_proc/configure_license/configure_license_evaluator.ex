defmodule TrainSwarmProc.ConfigureLicense.Evaluator do
  @moduledoc """
  Commanded handler for configuring the swarm training process.
  """
  @behaviour Commanded.Commands.Handler

  import Flags

  alias Schema.SwarmLicense.Status, as: Status
  alias TrainSwarmProc.Aggregate, as: Agg
  alias TrainSwarmProc.ConfigureLicense.CmdV1, as: ConfigureLicense
  alias TrainSwarmProc.ConfigureLicense.EvtV1, as: LicenseConfigured

  @impl Commanded.Commands.Handler
  ######################## CONFIGURE LICENSE ########################
  def handle(%Agg{status: status}, %ConfigureLicense{} = cmd) do
    if status
       |> has?(Status.license_initialized()) do
      raise_configured(cmd)
    else
      {:error, :not_initialized}
    end
  end


  defp raise_configured(cmd) do
    case LicenseConfigured.from_map(%LicenseConfigured{}, cmd) do
      {:ok, evt} ->
        evt

      {:error, reason} ->
        Logger.error("invalid configuration command => #{inspect(cmd)}")
        {:error, reason}
    end
  end


end

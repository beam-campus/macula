defmodule TrainSwarmProc.BlockLicense.Evaluator do
  @moduledoc """
  Commanded handler for blocking the swarm training process.
  """

  @behaviour Commanded.Commands.Handler


  alias Schema.SwarmLicense.Status, as: Status
  alias TrainSwarmProc.Aggregate, as: Agg

  import Flags
  require Logger


  ########################### BLOCK LICENSE ###########################
  alias TrainSwarmProc.BlockLicense.CmdV1, as: BlockLicense
  alias TrainSwarmProc.BlockLicense.EvtV1, as: LicenseBlocked

  @impl Commanded.Commands.Handler
  def handle(%Agg{} = _agg, %BlockLicense{} = cmd) do
    raise_blocked(cmd)
  end

  defp raise_blocked(cmd) do
    case LicenseBlocked.from_map(%LicenseBlocked{}, cmd) do
      {:ok, evt} ->
        evt

      {:error, reason} ->
        Logger.error("invalid block command => #{inspect(cmd)}")
        {:error, reason}
    end
  end


end

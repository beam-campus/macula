defmodule TrainSwarmProc.DetachScape.Evaluator do
  @moduledoc """
  Commanded handler for detaching the edge from the swarm training process.
  """
  @behaviour Commanded.Commands.Handler

  require Logger

  alias TrainSwarmProc.DetachScape.CmdV1, as: DetachScape
  alias TrainSwarmProc.DetachScape.EvtV1, as: ScapeDetached
  ########################## DETACH EDGE ##########################
  @impl Commanded.Commands.Handler
  def handle(_agg, %DetachScape{} = cmd) do
    raise_detached(cmd)
  end


  ######################## RAISE FUNCTIONS ########################
  defp raise_detached(%DetachScape{} = cmd) do
    case ScapeDetached.from_map(%ScapeDetached{}, cmd) do
      {:ok, evt} ->
        evt

      {:error, reason} ->
        Logger.error("invalid DETACH command => #{inspect(cmd)} reason: #{inspect(reason)}")
        {:error, reason}
    end
  end






end

defmodule TrainSwarmProc do
  @moduledoc """
  TrainSwarmProc is the context module for the TrainSwarm aggregate/process.
  """

  alias Schema.SwarmLicense, as: SwarmLicense
  alias Scape.Boundaries, as: Boundaries

  alias TrainSwarmProc.CommandedApp, as: TrainSwarmApp
  alias TrainSwarmProc.InitializeLicense.CmdV1, as: Initialize

  require Logger

  @agg_id "agg_id"
  @user_id "user_id"

  def change_swarm_license(%SwarmLicense{} = seed, %{} = map) do
    seed
    |> SwarmLicense.changeset(map)
  end

  def initialize(%{@agg_id => agg_id, @user_id => user_id} = license_request_params) do
    seed = %SwarmLicense{
      license_id: agg_id,
      user_id: user_id
    }

    case SwarmLicense.from_map(seed, license_request_params) do
      {:ok, license} ->
        initialize = %Initialize{
          agg_id: agg_id,
          payload: license
        }

        TrainSwarmApp.dispatch(initialize, metadata: %{@user_id => user_id})

      {:error, changeset} ->
        Logger.error("\n\n\nInvalid license request params \n\n\n #{inspect(changeset)} \n\n\n")
        {:error, "Invalid license request params #{inspect(changeset)}"}
    end
  end

  def initialize(%SwarmLicense{license_id: license_id} = license) do
    initialize = %Initialize{
      agg_id: license_id,
      payload: license
    }

    TrainSwarmApp.dispatch(initialize)
  end
end

defmodule TrainSwarmProc.PayLicense.CmdV1 do
  @moduledoc """
  PayLicense command schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  require Logger

  alias TrainSwarmProc.PayLicense.CmdV1, as: PayLicense
  alias Schema.SwarmLicense, as: Payment

  @all_fields [:agg_id, :payload]
  @required_fields [:agg_id, :payload]

  @primary_key false
  embedded_schema do
    field(:agg_id, :binary_id)
    embeds_one(:payload, Payment)
  end

  def changeset(%PayLicense{} = seed, params \\ %{}) do
    seed
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
  end

  def from_map(seed, map) when is_struct(map) do
    from_map(seed, Map.from_struct(map))
  end

  def from_map(seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create PayLicense from map: #{inspect(map)}")
        {:error, changeset}
    end
  end
end

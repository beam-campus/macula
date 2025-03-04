defmodule TrainSwarmProc.BlockLicense.EvtV1 do
  use Ecto.Schema

  import Ecto.Changeset

  require Logger

  require Jason.Encoder

  alias TrainSwarmProc.BlockLicense.PayloadV1, as: BlockInfo
  alias TrainSwarmProc.BlockLicense.EvtV1, as: Blocked


  @all_fields [
    :agg_id,
    :version,
    :payload
  ]

  @flat_fields [
    :agg_id,
    :version
  ]

  @required_fields [
    :agg_id,
    :version,
    :payload
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:agg_id, :binary_id)
    field(:version, :integer, default: 1)
    embeds_one(:payload, BlockInfo)
  end

  def changeset(%Blocked{} = seed, attrs) when is_struct(attrs),
    do: changeset(seed, Map.from_struct(attrs))

  def changeset(%Blocked{} = seed, attrs) when is_map(attrs) do
    seed
    |> cast(attrs, @flat_fields)
    |> cast_embed(:payload, with: &BlockInfo.changeset/2)
    |> validate_required(@required_fields)
  end

  def from_map(seed, map) when is_struct(map),
    do: from_map(seed, Map.from_struct(map))

  def from_map(%Blocked{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok,  apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create Blocked event from map: #{inspect(map)}")
        {:error, changeset}
    end
  end


end

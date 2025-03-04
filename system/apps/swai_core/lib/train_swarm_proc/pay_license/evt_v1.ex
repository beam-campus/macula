defmodule TrainSwarmProc.PayLicense.EvtV1 do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias TrainSwarmProc.PayLicense.EvtV1, as: LicensePaid
  alias Schema.SwarmLicense, as: Payment

  require Jason.Encoder
  require Logger

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

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:agg_id, :binary_id)
    field(:version, :integer, default: 1)
    embeds_one(:payload, Payment)
  end

  def changeset(%LicensePaid{} = seed, attrs) when is_struct(attrs),
    do: changeset(seed, Map.from_struct(attrs))

  def changeset(%LicensePaid{} = seed, params) when is_map(params) do
    seed
    |> cast(params, @flat_fields)
    |> cast_embed(:payload, with: &Payment.changeset/2)
    |> validate_required(@required_fields)
  end

  def from_map(%LicensePaid{} = seed, map) when is_struct(map),
    do: from_map(seed, Map.from_struct(map))

  def from_map(%LicensePaid{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create LicensePaid from map: #{inspect(map)}")
        {:error, changeset}
    end
  end
end

defmodule TrainSwarmProc.ReserveLicense.CmdV1 do
  @moduledoc """
  Command module for ReserveLicense
  """
  use Ecto.Schema
  import Ecto.Changeset

  require Logger
  require Jason.Encoder

  alias Schema.SwarmLicense, as: License

  @all_fields [
    :agg_id,
    :version,
    :payload
  ]

  @required_fields [
    :agg_id,
    :version,
    :payload
  ]

  @flat_fields [
    :agg_id,
    :version
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:agg_id, :binary_id)
    field(:version, :integer, default: 1)
    embeds_one(:payload, License)
  end

  def changeset(seed, attrs) when is_struct(attrs),
    do: changeset(seed, Map.from_struct(attrs))

  def changeset(seed, attrs) when is_map(attrs) do
    seed
    |> cast(attrs, @flat_fields)
    |> cast_embed(:payload, with: &License.changeset/2)
    |> validate_required(@required_fields)
  end

  def from_map(seed, attrs) do
    case changeset(seed, attrs) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end
end

defmodule TrainSwarmProc.ReserveLicense.EvtV1 do
  @moduledoc """
  This module is responsible for defining the events that can occur when reserving a license.
  """
  use Ecto.Schema
  import Ecto.Changeset

  require Logger
  require Jason.Encoder

  alias Schema.SwarmLicense, as: License

  @all_fields [:agg_id, :version, :payload]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:agg_id, :string)
    field(:version, :integer, default: 1)
    embeds_one(:payload, License, on_replace: :delete)
  end

  def changeset(seed, struct) when is_struct(struct),
    do: changeset(seed, Map.from_struct(struct))

  def changeset(seed, map) when is_map(map) do
    seed
    |> cast(map, [:agg_id, :version])
    |> cast_embed(:payload, with: &License.changeset/2)
    |> validate_required(@all_fields)
  end

  def from_map(seed, map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end
end

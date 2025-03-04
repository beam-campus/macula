defmodule TrainSwarmProc.PauseLicense.EvtV1 do
  @moduledoc """
  The event module for pausing a swarm training scape.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Schema.SwarmLicense, as: License
  alias TrainSwarmProc.PauseLicense.EvtV1, as: LicensePaused

  require Logger
  require Jason.Encoder

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
    embeds_one(:payload, License)
  end

  def changeset(%LicensePaused{} = evt, %{} = attrs) do
    evt
    |> cast(attrs, @flat_fields)
    |> cast_embed(:payload, with: &License.changeset/2)
    |> validate_required(@required_fields)
  end

  def from_map(%LicensePaused{} = seed, map) when is_struct(map),
    do: from_map(seed, Map.from_struct(map))

  def from_map(%LicensePaused{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create LicensePaused from map: #{inspect(changeset)}")
        {:error, changeset}
    end
  end

  defimpl String.Chars,
    for: LicensePaused do
    def to_string(evt) do
      Jason.encode!(evt)
    end
  end
end

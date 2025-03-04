defmodule TrainSwarmProc.InitializeLicense.EvtV1 do
  @moduledoc """
  Event module for TrainSwarmProc.InitializeLicense
  """
  use Ecto.Schema

  alias Schema.SwarmLicense, as: Initialization
  alias TrainSwarmProc.InitializeLicense.EvtV1, as: Initialized

  require Jason.Encoder
  require Logger
  import Ecto.Changeset

  @all_fields [
    :agg_id,
    :version,
    :payload
  ]

  @flat_fields [
    :agg_id,
    :version
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:agg_id, :binary_id)
    field(:version, :integer, default: 1)
    embeds_one(:payload, Initialization)
  end

  def changeset(%Initialized{} = evt, attrs) do
    evt
    |> cast(attrs, @flat_fields)
    |> cast_embed(:payload, with: &Initialization.changeset/2)
    |> validate_required(@all_fields)
  end

  def from_map(%Initialized{} = seed, map) when is_struct(map),
    do: from_map(seed, Map.from_struct(map))

  def from_map(%Initialized{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create Initialize from map: #{inspect(map)}")
        {:error, changeset}
    end
  end
end

defmodule TrainSwarmProc.InitializeLicenseScape.EvtV1 do
  @moduledoc """
  EvtV1 contains the events for initializing the swarm training process.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias TrainSwarmProc.InitializeLicenseScape.EvtV1, as: ScapeInitialized

  alias Scape.Init, as: ScapeInit

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
    embeds_one(:payload, ScapeInit)
  end

  def changeset(%ScapeInitialized{} = evt, %{} = attrs) do
    evt
    |> cast(attrs, @flat_fields)
    |> cast_embed(:payload, with: &ScapeInit.changeset/2)
    |> validate_required(@required_fields)
  end

  def from_map(%ScapeInitialized{} = seed, map) when is_struct(map),
    do: from_map(seed, Map.from_struct(map))

  def from_map(%ScapeInitialized{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create ScapeInitialized from map: #{inspect(map)}")
        {:error, changeset}
    end
  end

  defimpl String.Chars,
    for: ScapeInitialized do
    def to_string(evt) do
      Jason.encode!(evt)
    end
  end




end

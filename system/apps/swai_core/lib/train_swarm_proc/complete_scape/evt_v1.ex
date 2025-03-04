defmodule TrainSwarmProc.CompleteScape.EvtV1 do
  @moduledoc """
  The event module for completing a swarm training scape.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias TrainSwarmProc.CompleteScape.EvtV1, as: ScapeCompleted
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

  def changeset(%ScapeCompleted{} = evt, %{} = attrs) do
    evt
    |> cast(attrs, @flat_fields)
    |> cast_embed(:payload, with: &ScapeInit.changeset/2)
    |> validate_required(@required_fields)
  end

  def from_map(%ScapeCompleted{} = seed, map) when is_struct(map),
    do: from_map(seed, Map.from_struct(map))

  def from_map(%ScapeCompleted{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create ScapeCompleted from map: #{inspect(map)}")
        {:error, changeset}
    end
  end

  defimpl String.Chars,
    for: ScapeCompleted do
    def to_string(%ScapeCompleted{} = evt) do
      Jason.encode!(evt)
    end
  end
end

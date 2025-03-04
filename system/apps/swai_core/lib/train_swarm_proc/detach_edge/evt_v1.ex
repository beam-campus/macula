defmodule TrainSwarmProc.DetachEdge.EvtV1 do
  use Ecto.Schema

  import Ecto.Changeset

  require Jason.Encoder
  require Logger

  alias Edge.Init, as: EdgeInit
  alias TrainSwarmProc.DetachEdge.EvtV1, as: EdgeDetached

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
    embeds_one(:payload, EdgeInit)
  end

  def changeset(%EdgeDetached{} = evt, struct)
      when is_struct(struct),
      do: changeset(evt, Map.from_struct(struct))

  def changeset(%EdgeDetached{} = evt, %{} = attrs)
  when is_map(attrs) do
    evt
    |> cast(attrs, @flat_fields)
    |> cast_embed(:payload, with: &EdgeInit.changeset/2)
    |> validate_required(@all_fields)
  end

  def from_map(%EdgeDetached{} = seed, struct) when is_struct(struct),
    do: from_map(seed, Map.from_struct(struct))

  def from_map(%EdgeDetached{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("

        Failed to create EdgeDetached

        from map: #{inspect(map)}

        error: #{inspect(changeset)}

        ")
        {:error, changeset}
    end
  end
end

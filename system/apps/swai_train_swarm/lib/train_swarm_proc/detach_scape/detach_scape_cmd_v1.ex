defmodule TrainSwarmProc.DetachScape.CmdV1 do
  @moduledoc """
  The command to detach an edge
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias TrainSwarmProc.DetachScape.CmdV1, as: DetachScape
  alias Edge.Init, as: EdgeInit
  alias Scape.Init, as: ScapeInit
  alias Schema.SwarmLicense, as: License

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
    embeds_one(:payload, ScapeInit, on_replace: :delete)
  end

  def changeset(seed, struct)
      when is_struct(struct),
      do: changeset(seed, Map.from_struct(struct))

  def changeset(seed, args)
      when is_map(args) do
    seed
    |> cast(args, @flat_fields)
    |> cast_embed(:payload, with: &ScapeInit.changeset/2)
    |> validate_required(@required_fields)
  end

  def from_map(seed, struct)
      when is_struct(struct),
      do: from_map(seed, Map.from_struct(struct))

  def from_map(%DetachScape{} = detach_edge, map)
      when is_map(map) do
    case changeset(detach_edge, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end
end

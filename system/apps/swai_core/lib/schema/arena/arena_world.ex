defmodule Schema.Arena.World do
  @moduledoc """
  Swai.Schema.Arena.World contains the Ecto schema for the World.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Schema.Arena.World, as: World
  alias Schema.Vector, as: Vector

  @all_fields [
  ]

  @required_fields [
    :dimensions
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    embeds_one(:dimensions, Vector, on_replace: :delete)
  end

  def changeset(world, struct) when is_struct(struct) do
    changeset(world, Map.from_struct(struct))
  end

  def changeset(world, args) when is_map(args) do
    world
    |> cast(args, @all_fields)
    |> cast_embed(:dimensions, with: &Vector.changeset/2)
    |> validate_required(@required_fields)
  end

  def default(),
    do: %World{
      dimensions: %Vector{
        x: 800,
        y: 600,
        z: 0
      }
    }

  def from_map(seed, struct)
      when is_struct(struct),
      do: from_map(seed, Map.from_struct(struct))

  def from_map(seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end
end

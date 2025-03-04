defmodule Swarm.Init do
  @moduledoc """
  Swarm.InitParams is a struct that holds the parameters for initializing a swarm.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Schema.Vector, as: Vector

  @all_fields [
    :id,
    :edge_id,
    :license_id,
    :swarm_id,
    :user_id,
    :biotope_id,
    :algorithm_id,
    :initial_swarm_size,
    :swarm_time_min,
    :swarm_size,
    :world_dimensions,
    :hive_entrance_coordinates
  ]

  @flat_fields [
    :id,
    :edge_id,
    :license_id,
    :swarm_id,
    :user_id,
    :biotope_id,
    :algorithm_id,
    :initial_swarm_size,
    :swarm_time_min,
    :swarm_size
  ]

  @required_fields [
    :id,
    :edge_id,
    :license_id,
    :swarm_id,
    :user_id,
    :biotope_id,
    :algorithm_id,
    :initial_swarm_size,
    :swarm_time_min,
    :world_dimensions,
  ]


  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:id, :binary_id, primary_key: true, default: UUID.uuid4())
    field(:edge_id, :binary_id)
    field(:license_id, :binary_id)
    field(:swarm_id, :binary_id)
    field(:user_id, :binary_id)
    field(:biotope_id, :binary_id)
    field(:algorithm_id, :binary_id)
    field(:initial_swarm_size, :integer)
    field(:swarm_time_min, :integer)
    field(:swarm_size, :integer)
    embeds_one(:world_dimensions, Vector, on_replace: :delete)
    embeds_one(:hive_entrance_coordinates, Vector, on_replace: :delete)
    field(:swarms, :map, default: %{})
  end

  def changeset(seed, struct)
      when is_struct(struct),
      do: changeset(seed, Map.from_struct(struct))

  def changeset(swarm, args)
      when is_map(args) do
    swarm
    |> cast(args, @flat_fields)
    |> cast_embed(:world_dimensions, with: &Vector.changeset/2)
    |> cast_embed(:hive_entrance_coordinates, with: &Vector.changeset/2)
    |> validate_required(@required_fields)
   end


end

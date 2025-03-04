defmodule Scape.Boundaries do
  use Ecto.Schema

  import Ecto.Changeset

  alias Scape.Boundaries, as: Boundaries

  require Logger
  require Jason.Encoder

  @all_fields [
    :min_nbr_of_hives,
    :max_nbr_of_hives,
    :min_swarm_generation,
    :max_swarm_generation,
    :min_arena_complexity,
    :max_arena_complexity,
    :min_resource_availability,
    :max_resource_availability,
    :min_arena_toxicity_level,
    :max_arena_toxicity_level
  ]

  @flat_fields [
    :min_nbr_of_hives,
    :max_nbr_of_hives,
    :min_swarm_generation,
    :max_swarm_generation,
    :min_arena_complexity,
    :max_arena_complexity,
    :min_resource_availability,
    :max_resource_availability,
    :min_arena_toxicity_level,
    :max_arena_toxicity_level
  ]

  @required_fields [
    :min_nbr_of_hives,
    :max_nbr_of_hives,
    :min_swarm_generation,
    :max_swarm_generation,
    :min_arena_complexity,
    :max_arena_complexity,
    :min_resource_availability,
    :max_resource_availability,
    :min_arena_toxicity_level,
    :max_arena_toxicity_level
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:min_nbr_of_hives, :integer, default: 1)
    field(:max_nbr_of_hives, :integer, default: 1)

    field(:min_swarm_generation, :float, default: 1.0)
    field(:max_swarm_generation, :float, default: 1.0)

    field(:min_arena_complexity, :float, default: 1.0)
    field(:max_arena_complexity, :float, default: 1.0)

    field(:min_resource_availability, :float, default: 1.0)
    field(:max_resource_availability, :float, default: 1.0)

    field(:min_arena_toxicity_level, :float, default: 1.0)
    field(:max_arena_toxicity_level, :float, default: 1.0)
  end

  def changeset(seed, struct)
      when is_struct(struct),
      do: changeset(seed, Map.from_struct(struct))

  def changeset(seed, params)
      when is_map(params) do
    seed
    |> cast(params, @flat_fields)
    |> validate_required(@required_fields)
  end

  def from_map(seed, map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end

  def default(), do: %Boundaries{}
end

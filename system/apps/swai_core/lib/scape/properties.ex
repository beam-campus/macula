defmodule Scape.Properties do
  use Ecto.Schema

  import Ecto.Changeset

  alias Scape.Boundaries, as: ScapeQuery

  require Logger
  require Jason.Encoder

  @all_fields [
    :nbr_of_hives,
    :min_swarm_generation,
    :max_swarm_generation,
    :arena_complexity,
    :resource_availability,
    :arena_toxicity_level
  ]

  @flat_fields [
    :nbr_of_hives,
    :min_swarm_generation,
    :max_swarm_generation,
    :arena_complexity,
    :resource_availability,
    :arena_toxicity_level
  ]

  @required_fields [
    :nbr_of_hives,
    :min_swarm_generation,
    :max_swarm_generation,
    :arena_complexity,
    :resource_availability,
    :arena_toxicity_level
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:nbr_of_hives, :integer, default: 1)
    field(:min_swarm_generation, :float, default: 1.0)
    field(:max_swarm_generation, :float, default: 1.0)
    field(:arena_complexity, :float, default: 1.0)
    field(:resource_availability, :float, default: 1.0)
    field(:arena_toxicity_level, :float, default: 1.0)
  end

  def changeset(seed, attrs)
      when is_map(attrs) do
    seed
    |> cast(attrs, @flat_fields)
    |> validate_required(@required_fields)
  end

  def changeset(seed, struct)
  when is_struct(struct),
    do: changeset(seed, struct |> Map.from_struct())

    def from_map(seed, map) do
      case changeset(seed, map) do
        %{valid?: true} = changeset ->
          {:ok, apply_changes(changeset)}
        changeset ->
          {:error, changeset}
      end
    end
end

defmodule Arena.Init do
  @moduledoc """
  This module is responsible for managing the arena in the system.
  """

  use Ecto.Schema

  import Ecto.Changeset

  require Logger
  require Jason.Encoder

  alias Arena.ArenaMap, as: ArenaMap
  alias Arena.Init, as: ArenaInit
  alias Arena.Status, as: ArenaStatus
  alias Scape.Init, as: ScapeInit
  alias Schema.Vector, as: Vector
  alias Swai.Defaults, as: Defaults
  alias Arena.Hexa, as: Hexa
  alias Hive.Init, as: HiveInit
  alias Arena.Element, as: ArenaElement

  @arena_status_unknown ArenaStatus.unknown()

  @hexa_size Defaults.arena_hexa_size()
  @map_width Defaults.arena_width()
  @map_height Defaults.arena_height()
  @maze_density Defaults.arena_maze_density()

  @all_fields [
    :arena_id,
    :edge_id,
    :scape_id,
    :scape_name,
    :hives_cap,
    :biotope_id,
    :dimensions,
    :hexa_size,
    :max_hexa,
    :arena_map,
    :maze,
    :features,
    :collectibles,
    :hives,
    :arena_status
  ]

  @required_fields [
    :arena_id,
    :edge_id,
    :scape_id,
    :biotope_id,
    :hives_cap,
    :hexa_size
  ]

  @flat_fields [
    :arena_id,
    :edge_id,
    :scape_id,
    :scape_name,
    :biotope_id,
    :hives_cap,
    :hexa_size
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:arena_id, :string, default: "rna-#{UUID.uuid4()}")
    field(:edge_id, :string)
    field(:scape_id, :string)
    field(:biotope_id, :binary_id)
    field(:hives_cap, :integer)
    field(:scape_name, :string)
    field(:arena_status, :integer, default: @arena_status_unknown)
    field(:hexa_size, :integer, default: @hexa_size)
    embeds_one(:dimensions, Vector, on_replace: :delete)
    embeds_one(:max_hexa, Hexa, on_replace: :delete)
    embeds_one(:arena_map, ArenaMap, on_replace: :delete)
    embeds_many(:hives, HiveInit, on_replace: :delete)
    embeds_many(:maze, ArenaElement, on_replace: :delete)
    embeds_many(:features, ArenaElement, on_replace: :delete)
    embeds_many(:collectibles, ArenaElement, on_replace: :delete)
  end

  def changeset(seed, struct)
      when is_struct(struct),
      do: changeset(seed, Map.from_struct(struct))

  def changeset(arena, args)
      when is_map(args) do
    arena
    |> cast(args, @flat_fields)
    |> cast_embed(:dimensions, with: &Vector.changeset/2)
    |> cast_embed(:arena_map, with: &ArenaMap.changeset/2)
    |> cast_embed(:hives, with: &HiveInit.changeset/2)
    |> cast_embed(:maze, with: &ArenaElement.changeset/2)
    |> cast_embed(:max_hexa, with: &Hexa.changeset/2)
    |> validate_required(@required_fields)
    |> do_calculate_max_hexa()
  end

  defp do_calculate_max_hexa(changeset) do
    dimensions =
      changeset
      |> get_field(:dimensions)

    max_hexa = Arena.Hexa.cartesian_to_axial(dimensions, @hexa_size)

    changeset
    |> put_change(:max_hexa, max_hexa)
  end

  def from_map(seed, map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create arena: #{inspect(changeset, pretty: true)}")
        {:error, changeset}
    end
  end

  def default do
    seed =
      %ArenaInit{
        arena_id: "rna-#{UUID.uuid4()}",
        edge_id: "e-#{UUID.uuid4()}",
        scape_id: "scp-#{UUID.uuid4()}",
        biotope_id: UUID.uuid4(),
        hives_cap: 4,
        scape_name: "N/A",
        arena_map:
          ArenaMap.generate(
            @map_width,
            @map_height,
            @hexa_size,
            @maze_density,
            1
          ),
        dimensions: ArenaMap.default_dimensions()
      }

    seed
  end

  def new(%ScapeInit{hives_cap: hives_cap} = scape_init) do
    seed =
      %ArenaInit{
        arena_id: "arena-#{UUID.uuid4()}",
        arena_map:
          ArenaMap.generate(
            @map_width,
            @map_height,
            @hexa_size,
            @maze_density,
            hives_cap
          ),
        dimensions: ArenaMap.default_dimensions(),
        hives: ArenaMap.generate_hives([], hives_cap),
        maze: ArenaMap.generate_maze([], @map_width, @map_height, @hexa_size, @maze_density)
      }

    seed
    |> from_map(scape_init)
  end
end

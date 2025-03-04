defmodule Region.Init do
  @moduledoc """
  Region.Init is the struct that identifies the state of a Region.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Region.Init, as: RegionInit

  @all_fields [
    :id,
    :edge_id,
    :scape_id,
    :name,
    :nbr_of_farms,
    :continent,
    :continent_region,
  ]

  @required_fields [
    :id,
    :edge_id,
    :scape_id,
    :name,
    :nbr_of_farms,
    :continent,
    :continent_region,
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:edge_id, :string)
    field(:scape_id, :string)
    field(:name, :string)
    field(:nbr_of_farms, :integer)
    field(:continent, :string)
    field(:continent_region, :string)
  end

  def random(edge_id, scape_id, id, name, continent, continent_region) do
    %Region.Init{
      edge_id: edge_id,
      scape_id: scape_id,
      id: id,
      name: name,
      nbr_of_farms: :rand.uniform(5),
      continent: continent,
      continent_region: continent_region,
    }
  end

  def default(edge_id, scape_id),
    do: %Region.Init{
      edge_id: edge_id,
      scape_id: scape_id,
      id: "belgium",
      name: "Belgium",
      nbr_of_farms: 3,
      continent: "Europe",
      continent_region: "Western Europe"
    }

  def from_map(map) when is_map(map) do
    case(changeset(%RegionInit{}, map)) do
      %{valid?: true} = changeset ->
        region_init =
          changeset
          |> apply_changes()

        {:ok, region_init}

      changeset ->
        {:error, changeset}
    end
  end

  def changeset(region, args)
      when is_map(args),
      do:
        region
        |> cast(args, @all_fields)
        |> validate_required(@required_fields)
end

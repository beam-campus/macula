defmodule Schema.Region do
  use Ecto.Schema
  @moduledoc """
    Swai.Schema.Region contains the schema for Regions that make up a Scape
    A Region is a grouping of Farms
  """
  import Ecto.Changeset

  alias Schema.Farm
  alias Schema.Id
  require Jason

  @all_fields [
    :id,
    :name,
    :description,
    :flag,
    :farms
  ]


  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    field(:description, :string)
    field(:flag, :string, default: "🇺🇳")
    embeds_many(:farms, Schema.Farm)
  end

  defp id_prefix, do: "region"

  def changeset(region, args) do
    region
    |> cast(args, [
      :name,
      :description
    ])
    |> cast_embed(
      :farms,
      required: false,
      with: &Farm.changeset/2
    )
    |> validate_required([
      :name
    ])
  end

  def new(args) do
    case changeset(%__MODULE__{}, args) do
      %{valid?: true} = changeset ->
        region =
          changeset
          |> apply_changes()
          |> Map.put(:id, Id.new(id_prefix()) |> Id.as_string())

        {:ok, region}

      changeset ->
        {:error, changeset}
    end
  end
end

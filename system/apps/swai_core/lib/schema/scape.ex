defmodule Schema.Scape do
  use Ecto.Schema

  @moduledoc """
  Swai.Schema.Scape contains the Ecto schema for the Scape.
  """

  import Ecto.Changeset

  alias Edge.Init, as: Edge
  alias Schema.Scape, as: Scape

  def id_prefix(), do: "scape"

  @all_fields [
    :id,
    :name,
    :description,
    :image_url,
    :tags,
    :sourced_by
  ]

  @flat_fields [
    :id,
    :name,
    :description,
    :image_url,
    :tags
  ]

  @required_fields [
    :name
  ]

  @required_fields [:name]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:id, :binary_id, default: UUID.uuid4())
    field(:name, :string)
    field(:description, :string, default: "")
    field(:image_url, :string, default: "")
    field(:tags, :string)
    embeds_many(:sourced_by, Edge)
    embeds_one(:license, License)
  end

  def changeset(seed, struct)
      when is_struct(struct),
      do: changeset(seed, Map.from_struct(struct))

  def changeset(scape, args)
      when is_map(args) do
    scape
    |> cast(args, @flat_fields)
    |> cast_embed(:sourced_by, with: &Edge.changeset/2)
    |> validate_required(@required_fields)
  end

  def from_map(seed, struct)
      when is_struct(struct),
      do: from_map(seed, Map.from_struct(struct))

  def from_map(map) when is_map(map) do
    case changeset(%Scape{}, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end

end

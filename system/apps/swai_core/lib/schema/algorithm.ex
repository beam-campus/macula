defmodule Schema.Algorithm do
  use Ecto.Schema

  import Ecto.Changeset

  alias Schema.Algorithm, as: Algorithm

  @all_fields [
    :id,
    :acronym,
    :name,
    :description,
    :image_url,
    :definition,
    :tags
  ]

  @required_fields [
    :id,
    :acronym,
    :name
  ]

  @primary_key false
  schema "algorithms" do
    field(:id, :binary_id, primary_key: true)
    field(:acronym, :string)
    field(:name, :string)
    field(:description, :string)
    field(:image_url, :string)
    field(:definition, :string)
    field(:tags, :string)
    timestamps()
  end

  def changeset(algorithm, params \\ %{}) do
    algorithm
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
  end

  def from_map(%Algorithm{} = seed, map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end
end

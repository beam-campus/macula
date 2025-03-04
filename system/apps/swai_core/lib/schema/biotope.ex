defmodule Schema.Biotope do
  @moduledoc """
  The schema for the biotopes table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @all_fields [
    :id,
    :algorithm_id,
    :algorithm_acronym,
    :algorithm_name,
    :name,
    :description,
    :image_url,
    :theme,
    :tags,
    :objectives,
    :challenges,
    :environment,
    :is_active?,
    :is_realistic?
  ]

  @id_fields [
    :id,
    :algorithm_id,
    :algorithm_acronym,
    :algorithm_name,
    :name
  ]


  @primary_key false
  schema "biotopes" do
    field(:id, :binary_id, primary_key: true)
    field(:algorithm_id, :binary_id)
    field(:algorithm_acronym, :string)
    field(:algorithm_name, :string)
    field(:name, :string)
    field(:description, :string)
    field(:image_url, :string)
    field(:theme, :string)
    field(:tags, :string)
    field(:objectives, :string)
    field(:challenges, :string)
    field(:environment, :string)
    field(:is_active?, :boolean, default: false)
    field(:is_realistic?, :boolean, default: false)
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(biotope, attrs) do
    biotope
    |> cast(attrs, @all_fields)
    |> validate_required(@id_fields)
  end

  @doc false
  def from_map(%Schema.Biotope{} = biotope, attrs) do
    case changeset(biotope, attrs) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end



end

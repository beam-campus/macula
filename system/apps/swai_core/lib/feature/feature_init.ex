defmodule Feature.Init do
  use Ecto.Schema

  @moduledoc """
  Feature.InitParams is a struct that holds the parameters for initializing a feature.
  """

  import Ecto.Changeset

  require Logger
  require Jason.Encoder

  @all_fields [
    :name,
    :description,
    :type,
    :tags,
    :image_url,
    :orientation,
    :scale,
    :color,
    :opacity,
    :size,
    :shape,
    :intensity
  ]

  @required_fields [
    :type,
    :color,
    :intensity
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:name, :string)
    field(:description, :string, default: "")
    field(:type, :string)
    field(:tags, :string)
    field(:image_url, :string, default: "")
    field(:orientation, :float)
    field(:scale, :float)
    field(:color, :string)
    field(:opacity, :float)
    field(:size, :float)
    field(:shape, :string)
    field(:intensity, :float, default: 1.0)
  end

  def changeset(seed, struct)
      when is_struct(struct),
      do: changeset(seed, Map.from_struct(struct))

  def changeset(seed, args)
      when is_map(args) do
    seed
    |> cast(args, @all_fields)
    |> validate_required(@required_fields)
  end

  def from_map(feature, args)
      when is_map(args) do
    case changeset(feature, args) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}
      changeset  ->
        {:error, changeset}
    end
  end
end

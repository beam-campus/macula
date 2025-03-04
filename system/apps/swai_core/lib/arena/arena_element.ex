defmodule Arena.Element do
  @moduledoc """
  This module is responsible for managing the arena element in the system.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Feature.Init, as: Feature
  alias Arena.Hexa, as: Hexa

  @all_fields [
    :hexa,
    :feature
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    embeds_one(:hexa, Arena.Hexa)
    embeds_one(:feature, Feature)
  end

  def changeset(arena_element, attrs)
      when is_map(attrs) do
    arena_element
    |> cast(attrs, [])
    |> cast_embed(:hexa, with: &Hexa.changeset/2)
    |> cast_embed(:feature, with: &Feature.changeset/2)
    |> validate_required(@all_fields)
  end

  def changeset(seed, attrs) when is_struct(attrs),
    do: changeset(seed, Map.from_struct(attrs))
end

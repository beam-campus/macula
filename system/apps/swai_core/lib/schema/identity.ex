defmodule Schema.Identity do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema.Identity is a module that contains the schema for a given Identity
  """

  @all_fields [
    :edge_id,
    :scape_id,
    :region_id,
    :farm_id,
    :hive_id,
    :drone_id,
  ]


  @required_fields [
    :edge_id,
    :scape_id,
    :region_id,
    :farm_id,
    :drone_id,
  ]

  alias Schema.Identity

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:edge_id, :string)
    field(:scape_id, :string)
    field(:region_id, :string)
    field(:farm_id, :string)
    field(:hive_id, :string)
    field(:drone_id, :string)
  end


  def changeset(id, args) do
    id
    |> cast(args, @all_fields)
    |> validate_required(@required_fields)
  end

  def new(args) when is_map(args) do
    case changeset(%Identity{}, args) do
      %{valid?: true} = changeset ->
        changeset
        |> Ecto.Changeset.apply_changes()

      changeset ->
        {:error, changeset}
    end
  end


end

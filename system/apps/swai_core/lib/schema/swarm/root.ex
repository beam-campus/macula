defmodule Schema.Swarm do
  @moduledoc """
  The schema for the Swarm model.
  """
  use Ecto.Schema

  import Ecto.Changeset

  require MnemonicSlugs

  @all_fields [
    :id,
    :name,
    :status,
    :description,
    :edge_id,
    :user_id,
    :biotope_id,
    :size,
    :budget,
    :ranking,
    :quality,
    :generation
  ]

  embedded_schema do
    field(:name, :string)
    field(:status, :integer)
    field(:description, :string)
    field(:edge_id, :string)
    field(:user_id, :string)
    field(:biotope_id, :string)
    field(:size, :integer, default: 10)
    field(:budget, :integer, default: 1_000)
    field(:ranking, :integer, default: 10_000)
    field(:quality, :integer, default: 10)
    field(:generation, :integer, default: 1)
    
  end

  @doc false

  def changeset(swarm, attrs) do
    swarm
    |> cast(attrs, @all_fields)
    |> validate_required(@all_fields)
  end



end

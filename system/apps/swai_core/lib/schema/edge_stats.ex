defmodule Schema.EdgeStats do
  use Ecto.Schema

  @moduledoc """
  Schema.EdgeStats contains the Ecto schema for the edge stats.
  """

  import Ecto.Changeset

  alias Schema.EdgeStats,
    as: EdgeStats

  @all_fields [
    :nbr_of_agents,
    :nbr_of_scapes,
    :nbr_of_particles,
  ]

  @required_fields [
    :nbr_of_agents,
    :nbr_of_scapes,
    :nbr_of_particles
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:nbr_of_agents, :integer)
    field(:nbr_of_scapes, :integer)
    field(:nbr_of_particles, :integer)
  end


  def changeset(seed, struct)
      when is_struct(struct),
      do: changeset(seed, Map.from_struct(struct))

  def changeset(edge_stats, args)
      when is_map(args) do
    edge_stats
    |> cast(args, @all_fields)
    |> validate_required(@required_fields)
  end



  def from_map(seed, map) do
    case(changeset(seed, map)) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end

  def empty do
    %EdgeStats{
      nbr_of_agents: 0,
      nbr_of_scapes: 0,
      nbr_of_particles: 0
    }
  end
end

defmodule Schema.RequestToSwarm do
  @moduledoc """
  The  Schema.RequestToSwarm  module defines the schema for the  swarm_specs  table. The schema has fields for the name, description, image, command, environment variables, ports, networks, volumes, and replicas. The  changeset  function is used to cast and validate the attributes.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Schema.RequestToSwarm
  alias Schema.RequestToSwarm, as: SwarmSpec

  @all_fields [
    :license_id,
    :user_id,
    :biotope_id,
    :name,
    :edge_id,
    :budget,
    :generations,
    :size,
    :start_time,
  ]

  @required_fields [
    :license_id,
    :user_id,
    :biotope_id,
    :budget,
    :generations,
    :size
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field(:license_id, :binary_id)
    field(:user_id, :binary_id)
    field(:biotope_id, :binary_id)
    field(:name, :string)
    field(:edge_id, :binary_id)
    field(:budget, :integer)
    field(:generations, :integer)
    field(:size, :integer)
    field(:start_time, :utc_datetime_usec)
  end

  @doc false
  def changeset(swarm_spec, attrs) do
    swarm_spec
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end

  def empty do
    %SwarmSpec{}
  end
end

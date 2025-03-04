defmodule Scape.ExecutionInfo do
  @moduledoc """
  ExecutionInfo is a struct that holds the parameters for initializing a scape.
  """

  use Ecto.Schema

  import Ecto.Changeset

  require Logger
  require Jason.Encoder

  alias Scape.ExecutionInfo, as: ExecutionInfo

  @all_fields [
    :edge_id,
    :status,
    :start_time,
    :end_time
  ]

  @required_fields [
    :edge_id,
    :status,
    :start_time,
    :end_time
  ]


  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field :edge_id, :binary_id
    field :status, :integer
    field :start_time, :utc_datetime_usec
    field :end_time, :utc_datetime_usec
  end


  def changeset(%ExecutionInfo{} = execution_info, attrs) do
    execution_info
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end





end

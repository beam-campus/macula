defmodule Nature.Init do
  use Ecto.Schema

  @moduledoc """
  Nature.Init is a GenServer that initializes the nature of a farm.
  """

  @all_fields [
    :id,
    :edge_id,
    :scape_id,
    :region_id,
    :mng_farm_id,
    :field_id,
    # :col,
    # :row,
    # :depth,
    # :influence_dimension,
    :max_pct_good,
    :max_pct_bad
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:id, :id)
    field(:edge_id, :id)
    field(:scape_id, :id)
    field(:region_id, :id)
    field(:mng_farm_id, :id)
    field(:field_id, :id)
    field(:max_pct_good, :integer)
    field(:max_pct_bad, :integer)
  end
end

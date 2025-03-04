defmodule Service.Scapes.Region do
  use Ecto.Schema

  @moduledoc """
  Service.Scapes.Region contains the Ecto schema for the Region.
  """

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:edge_id, :string)
    field(:scape_id, :string)
    field(:name, :string)
    field(:description, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    embeds_many(:sourced_by, Swai.Stations.Station)
    embeds_many(:farms, Service.Scapes.Farm)
  end

end

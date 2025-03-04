defmodule Schema.Arena do
  @moduledoc """
  Swai.Schema.Arena contains the Ecto schema for the Arena.
  """
  use Ecto.Schema


  import Ecto.Changeset


  alias Schema.Vector, as: Vector

  @all_fields [
    :id,
  ]

  @flat_fields [
    :id,
    :name,
    :description,
    :image_url,
    :tags
  ]

  @required_fields [
    :name
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:id, :binary_id, default: UUID.uuid4())
    embeds_one(:world_map, Vector, on_replace: :delete)
    embeds_many(:features, Feature)
  end







end

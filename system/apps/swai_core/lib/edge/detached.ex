defmodule SwaiEdge.Detached do
  use Ecto.Schema

  @moduledoc """
  Edge.Attached is a collection of all facts related to the edge used in the system.
  """
  alias Schema.Meta
  alias SwaiEdge.Detached.PayloadV1

  @topic_v1 "edge:detached:v1"

  def topic_v1, do: @topic_v1

  @primary_key false
  embedded_schema do
    embeds_one(:meta, Meta)
    embeds_one(:payload, PayloadV1)
  end



  def new(agg_id, order, correlation_id, causation_id, causation_type, edge_id) do
    %__MODULE__{
      meta:
        Meta.new(
          @topic_v1,
          agg_id,
          order,
          correlation_id,
          causation_id,
          causation_type
        ),
      payload: PayloadV1.new(edge_id)
    }
  end



  defmodule PayloadV1 do
    use Ecto.Schema

    @moduledoc """
    the payload for the edge:attached:v1 fact
    """
    @primary_key false
    embedded_schema do
      field(:edge_id, :string)
    end

    def new(edge_id), do: %__MODULE__{edge_id: edge_id}
  end
end

defmodule Schema.Meta do
  @moduledoc """
  Schema.Meta is the module that contains the facts for the Life Subsystem
  """
  use Ecto.Schema
  alias Schema.Id

  defguard is_meta(meta)
           when is_struct(meta, __MODULE__)

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:topic, :string)
    field(:agg_id, :string)
    field(:correlation_id, :string)
    field(:causation_id, :string)
    field(:causation_type, :integer)
    field(:order, :integer)
    field(:timestamp, :utc_datetime)
  end

  def new(
        topic,
        agg_id,
        order
      ),
      do: %__MODULE__{
        id:
          Id.new(topic)
          |> Id.as_string(),
        topic: topic,
        agg_id: agg_id,
        correlation_id: UUID.uuid4(:default),
        causation_id: UUID.uuid4(:default),
        causation_type: 0,
        order: order,
        timestamp: DateTime.utc_now()
      }

  def new(
        topic,
        agg_id,
        order,
        correlation_id,
        causation_id,
        causation_type
      ),
      do: %__MODULE__{
        id:
          Id.new(topic)
          |> Id.as_string(),
        topic: topic,
        agg_id: agg_id,
        correlation_id: correlation_id,
        causation_id: causation_id,
        causation_type: causation_type,
        order: order,
        timestamp: DateTime.utc_now()
      }
end

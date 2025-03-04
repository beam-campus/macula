defmodule Swai.Schema.Fact do
  @moduledoc """
  Swai.Schema.Fact is a data structure that represents Facts (Events) in the Swai system.
  """
  use Ecto.Schema
  alias Schema.Meta

  defguard is_fact(fact) when is_struct(fact, __MODULE__)

  @primary_key false
  embedded_schema do
    field(:topic, :string)
    embeds_one(:meta, Meta)
    embeds_one(:payload, :map)
  end

  def new(topic, meta, payload),
      do: %__MODULE__{
        topic: topic,
        meta: meta,
        payload: payload
      }

end

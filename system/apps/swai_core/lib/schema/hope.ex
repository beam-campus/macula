defmodule Swai.Schema.Hope do
  @moduledoc """
  Swai.Schema.Hope is a data structure that represents Hopes (Commands) in the Swai system.
  """
  use Ecto.Schema
  alias Schema.Meta

  defguard is_hope(hope) when is_struct(hope, __MODULE__)

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

defmodule Edge.Emitter do
  @moduledoc """
  Edge.Emitter is a GenServer that manages a channel to a scape,
  """
  alias Edge.Client, as: Client
  alias Edge.Facts, as: EdgeFacts

  require Logger

  @edge_initialized_v1 EdgeFacts.edge_initialized_v1()
  @initializing_edge_v1 EdgeFacts.initializing_edge_v1()

  # @attach_scape_v1 "attach_scape:v1"
  def emit_edge_initialized(%{edge_id: edge_id} = edge_init),
    do:
      Client.publish(
        edge_id,
        @edge_initialized_v1,
        %{edge_init: edge_init}
      )

  def emit_initializing_edge(%{edge_id: edge_id} = edge_init),
    do:
      Client.publish(
        edge_id,
        @initializing_edge_v1,
        %{edge_init: edge_init}
      )
end

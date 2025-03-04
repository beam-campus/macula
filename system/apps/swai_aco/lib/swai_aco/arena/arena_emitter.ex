defmodule Arena.Emitter do
  @moduledoc """
  Arena.Emitter is a GenServer that manages a channel to a scape,
  """
  alias Edge.Client, as: Client
  alias Arena.Facts, as: ArenaFacts
  alias Arena.Init, as: ArenaInit

  @arena_initialized_v1 ArenaFacts.arena_initialized_v1()

  require Logger

  def emit_arena_initialized(%ArenaInit{edge_id: edge_id} = arena_init),
    do:
      Client.publish(
        edge_id,
        @arena_initialized_v1,
        %{arena_init: arena_init}
      )
end

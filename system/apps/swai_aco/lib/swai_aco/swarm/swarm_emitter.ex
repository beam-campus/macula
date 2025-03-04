defmodule Swarm.Emitter do
  @moduledoc """
  Swarm.Emitter is a GenServer that manages a channel to a scape,
  """
  alias Edge.Client, as: Client
  alias Scape.Facts, as: ScapeFacts

  alias Scape.Init, as: ScapeInit
  alias Hive.Init, as: HiveInit
  alias Arena.Init, as: ArenaInit

  require Logger
end

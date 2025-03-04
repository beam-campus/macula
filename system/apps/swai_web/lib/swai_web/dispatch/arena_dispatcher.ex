defmodule SwaiWeb.ArenaDispatcher do
  @moduledoc false
  alias Commanded.PubSub

  require Logger
  require Phoenix.PubSub, as: PubSub

  alias Arena.Facts, as: ArenaFacts
  alias Arena.Init, as: ArenaInit

  @arena_facts ArenaFacts.arena_facts()
  @arena_initialized_v1 ArenaFacts.arena_initialized_v1()
  @arena_terminated_v1 ArenaFacts.arena_terminated_v1()

  def pub_arena_terminated(envelope) do
    case ArenaInit.from_map(%ArenaInit{}, envelope["arena_init"]) do
      {:ok, arena_init} ->
        Swai.PubSub
        |> PubSub.broadcast!(@arena_facts, {@arena_terminated_v1, arena_init})

      {:error, changeset} ->
        Logger.error("invalid ArenaInit envelope, reason: #{inspect(changeset)}")
        {:error, changeset}
    end
  end

  ######## ARENA INITIALIZED ########
  def pub_arena_initialized(envelope) do
    case ArenaInit.from_map(%ArenaInit{}, envelope["arena_init"]) do
      {:ok, arena_init} ->
        Swai.PubSub
        |> PubSub.broadcast!(@arena_facts, {@arena_initialized_v1, arena_init})

      {:error, changeset} ->
        Logger.error("invalid ArenaInit envelope, reason: #{inspect(changeset)}")
        {:error, changeset}
    end
  end
end

defmodule SwaiWeb.ScapeDispatcher do
  @moduledoc """
  The ScapeHandler is used to broadcast messages to all clients
  """

  alias Scape.Facts, as: ScapeFacts
  alias Scape.Init, as: ScapeInit
  alias Scapes.Service, as: Scapes

  alias Phoenix.PubSub, as: PubSub
  alias Swai.PubSub, as: SwaiPubSub

  require Logger

  @scape_detached_v1 ScapeFacts.scape_detached_v1()
  @scape_facts ScapeFacts.scape_facts()
  @scape_initializing_v1 ScapeFacts.scape_initializing_v1()
  @scape_initialized_v1 ScapeFacts.scape_initialized_v1()

  defp do_detach_scape(%ScapeInit{} = scape_init) do
    Logger.warning("Detaching scape: #{inspect(scape_init)}")

    SwaiPubSub
    |> PubSub.broadcast!(@scape_facts, {@scape_detached_v1, scape_init})
  end


  def detach_edge(edge_id) do
    case Scapes.get_for_edge(edge_id) do
      [] ->
        Logger.warning("detach_scapes: no scapes found for edge_id: #{edge_id}")
        []

      scapes ->
        scapes
        |> Enum.each(&do_detach_scape/1)

        scapes
    end
  end

  ########################## INITIALIZING SCAPE ##########################
  def pub_scape_initializing(envelope) do
    case ScapeInit.from_map(%ScapeInit{}, envelope["scape_init"]) do
      {:ok, scape_init} ->
        SwaiPubSub
        |> PubSub.broadcast!(
          @scape_facts,
          {@scape_initializing_v1, scape_init}
        )

      {:error, changeset} ->
        Logger.error("invalid envelope, reason: #{inspect(changeset)}")
        {:error, "invalid scape_init map"}
    end
  end

  ########################## SCAPE INITIALIZED ##########################
  def pub_scape_initialized(envelope) do
    case ScapeInit.from_map(%ScapeInit{}, envelope["scape_init"]) do
      {:ok, scape_init} ->
        SwaiPubSub
        |> PubSub.broadcast!(
          @scape_facts,
          {@scape_initialized_v1, scape_init}
        )

      {:error, changeset} ->
        Logger.error("invalid scape_init, reason: #{inspect(changeset)}")
        {:error, changeset}
    end
  end

  ########################## SCAPE DETACHED ##########################
  def pub_scape_detached(envelope) do
    case ScapeInit.from_map(%ScapeInit{}, envelope["scape_init"]) do
      {:ok, scape_init} ->
        SwaiPubSub
        |> PubSub.broadcast!(
          @scape_facts,
          {@scape_detached_v1, scape_init}
        )

      {:error, changeset} ->
        Logger.error("invalid envelope: #{inspect(changeset)}")
        {:error, changeset}
    end
  end
end

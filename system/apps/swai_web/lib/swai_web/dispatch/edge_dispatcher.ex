defmodule SwaiWeb.EdgeDispatcher do
  @moduledoc """
  The EdgeHandler is used to broadcast messages to all clients
  """
  alias Edge.Facts, as: EdgeFacts
  alias Edge.Init, as: EdgeInit
  alias Phoenix.PubSub, as: PubSub
  alias SwaiWeb.LicenseDispatcher, as: LicenseDispatcher
  alias SwaiWeb.ScapeDispatcher, as: ScapeDispatcher
  require Logger

  @edge_facts EdgeFacts.edge_facts()
  @edge_detached_v1 EdgeFacts.edge_detached_v1()
  @edge_attached_v1 EdgeFacts.edge_attached_v1()

  ################ CALLBACKS ################
  ## Edge Detached
  def pub_edge_detached(payload) do
    case EdgeInit.from_map(EdgeInit.default(), payload["edge_init"]) do
      {:ok, %EdgeInit{edge_id: edge_id} = edge_init} ->
        LicenseDispatcher.pause_licenses(edge_id)
        ScapeDispatcher.detach_edge(edge_id)
        #       HiveDispatcher.detach_edge(edge_id)

        Swai.PubSub
        |> PubSub.broadcast!(@edge_facts, {@edge_detached_v1, edge_init})

      {:error, _} ->
        Logger.error("pub_edge_detached: invalid edge_init")
    end
  end

  ## Edge Attached
  def pub_edge_attached(payload, socket) do
    Logger.info("pub_edge_attached #{inspect(payload)}")
    {:ok, edge_init} = EdgeInit.from_map(EdgeInit.default(), payload["edge_init"])

    edge_init =
      %Edge.Init{
        edge_init
        | socket: socket
      }

    Swai.PubSub
    |> PubSub.broadcast!(
      @edge_facts,
      {@edge_attached_v1, edge_init}
    )
  end
end

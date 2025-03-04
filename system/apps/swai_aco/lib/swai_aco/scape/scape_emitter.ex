defmodule Scape.Emitter do
  # use GenServer, restart: :transient
  @moduledoc """
  Scape.Emitter is a GenServer that manages a channel to a scape,
  """

  alias Edge.Client, as: Client
  alias Scape.Facts, as: ScapeFacts
  alias Scape.Init, as: ScapeInit

  @scape_detached_v1 ScapeFacts.scape_detached_v1()
  @scape_initialized_v1 ScapeFacts.scape_initialized_v1()
  @initializing_scape_v1 ScapeFacts.scape_initializing_v1()

  require Logger

  def emit_initializing_scape(%ScapeInit{edge_id: edge_id} = scape_init),
    do:
      Client.publish(
        edge_id,
        @initializing_scape_v1,
        %{scape_init: scape_init}
      )

  def emit_scape_initialized(%ScapeInit{edge_id: edge_id} = scape_init),
    do:
      Client.publish(
        edge_id,
        @scape_initialized_v1,
        %{scape_init: scape_init}
      )

  def emit_scape_detached(%ScapeInit{edge_id: edge_id} = scape_init),
    do:
      Client.publish(
        edge_id,
        @scape_detached_v1,
        %{scape_init: scape_init}
      )

  # @impl GenServer
  # def init(%ScapeInit{scape_id: scape_id} = scape_init) do
  #   Logger.debug("scape.emitter is up: #{Colors.scape_theme(self())} id: #{scape_id}")
  #   {:ok, scape_init}
  # end
  #
  # ##### PLUMBING #####
  # defp to_name(scape_id),
  #   do: "scape.emitter.#{scape_id}"
  #
  # def via(scape_id),
  #   do: Swai.Registry.via_tuple({:scape_channel, to_name(scape_id)})
  #
  # def start_link(%ScapeInit{scape_id: scape_id} = scape_init) do
  #   GenServer.start_link(
  #     __MODULE__,
  #     scape_init,
  #     name: via(scape_id)
  #   )
  # end
end

defmodule SwaiWeb.RingSocket do
  use Phoenix.Socket

  require Logger

  channel("ring:*", SwaiWeb.RingChannel)

  @impl true
  def connect(params, socket, connect_info) do
    Logger.debug("ringsocket connect params: #{inspect(params)}")
    Logger.debug("ringsocket connect socket: #{inspect(socket)}")
    Logger.debug("ringsocket connect connect_info: #{inspect(connect_info)}")    
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  # ff
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.Web.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(_socket) do
    # Logger.debug("EdgeSocket id: #{inspect(socket)}")
    "ring_socket"
    # do: "edge_socket:#{socket.assigns.edge_id}"
  end
end

defmodule SwaiWeb.EdgeSocket do
  use Phoenix.Socket

  require Logger

  # A Socket handler
  #
  # It's possible to control the websocket connection and
  # assign values that can be accessed by your channel topics.

  ## Channels
  # Uncomment the following line to define a "room:*" topic
  # pointing to the `Web.EdgeChannel`:
  #
  channel "edge:*", SwaiWeb.EdgeChannel
  channel "life:*", SwaiWeb.LifeChannel
  channel "my:*", SwaiWeb.MyChannel
  #
  # To create a channel file, use the mix task:
  #
  #     mix phx.gen.channel Room
  #
  # See the [`Channels guide`](https://hexdocs.pm/phoenix/channels.html)
  # for further details.

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error` or `{:error, term}`. To control the
  # response the client receives in that case, [define an error handler in the
  # websocket
  # configuration](https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#socket/3-websocket-configuration).
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl true
  def connect(params, socket, connect_info) do
    Logger.debug("edgesocket connect params: #{inspect(params)}")
    Logger.debug("edgesocket connect socket: #{inspect(socket)}")
    Logger.debug("edgesocket connect connect_info: #{inspect(connect_info)}")
    # assign(socket, :edge_id, params.edge_id)
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
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
    "edge_socket"
    # do: "edge_socket:#{socket.assigns.edge_id}"
  end
end

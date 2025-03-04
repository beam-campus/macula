defmodule SwaiWeb.My.Channel do
  use SwaiWeb, :channel

  @moduledoc """
  The MyChannel is used to broadcast messages to all clients
  """

  @impl true
  def join("my_channel:lobby", _payload, socket) do
      {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (my_channel:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end


end

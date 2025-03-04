defmodule SwaiWeb.LifeChannel do
  use SwaiWeb, :channel

  @moduledoc """
  The LifeChannel is used to broadcast messages to all clients
  """

  @life_lobby "life:lobby"

  require Logger

  @impl true
  def join("life:lobby", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("join", payload, socket) do
    Logger.debug("LifeChannel.handle_in: #{inspect(payload)}")
    {:ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (life:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end



end

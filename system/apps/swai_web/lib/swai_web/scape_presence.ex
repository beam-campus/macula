defmodule SwaiWeb.ScapePresence do
  @moduledoc """
  The EdgePresence is used to broadcast messages to all clients
  """
  use Phoenix.Presence,
    otp_app: :swai_web,
    pubsub_server: Swai.PubSub

  require Logger
end

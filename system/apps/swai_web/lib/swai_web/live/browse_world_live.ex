defmodule SwaiWeb.BrowseWorldLive do
  use SwaiWeb, :live_view

  @moduledoc """
  LiveView module for the WorldView component.
  """

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end

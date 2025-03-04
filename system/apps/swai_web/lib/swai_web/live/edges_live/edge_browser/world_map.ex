defmodule SwaiWeb.EdgeBrowser.WorldMap do
  @moduledoc """
  The live component for the world map.
  """
  use SwaiWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <div class="flex justify-center pt-10"
        id="edges-world-map-svg"
        phx-hook="TheMap"
        data-edges={Jason.encode!(@edges)}
      />

    """
  end

end

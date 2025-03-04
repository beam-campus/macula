defmodule SwaiWeb.ArenaMapView do
  use SwaiWeb, :live_component

  
  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center pt-auto w-full h-full">
      <div
      id={"arena-map-svg-#{@scape.scape_id}"}
      phx-hook="TheArena"
      data-scape_id={@scape.scape_id}
      data-arena_map={Jason.encode!(@arena.arena_map)}
      data-particles={Jason.encode!(@particles)}
      data-hives={Jason.encode!(@hives)}
      />
    </div>
    """
  end
end

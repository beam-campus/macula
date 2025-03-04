defmodule SwaiWeb.ArenaMap do
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
        id={"arena-map-svg-#{@scape.id}"}
        phx-hook="TheArena"
        data-scape={Jason.encode!(@scape)}
      />
    """
  end

end

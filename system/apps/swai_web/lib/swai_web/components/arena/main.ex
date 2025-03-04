defmodule SwaiWeb.Components.Arena do
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
    <div class="flex w-full">
        <.live_component
          id="edges-world-map"
          module={SwaiWeb.Components.ArenaMap}
          edges={@edges}
        />
    </div>
    """
  end

end

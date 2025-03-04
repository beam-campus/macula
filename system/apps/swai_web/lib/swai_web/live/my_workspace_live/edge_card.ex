defmodule SwaiWeb.EdgeCard do
  use SwaiWeb, :live_component

  alias Particles.Service, as: Particles

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
    <div id="workspace-trainings-section" class="mx-4">
    </div>
    """
  end


end

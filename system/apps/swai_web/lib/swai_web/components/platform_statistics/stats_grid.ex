defmodule SwaiWeb.PlatformStatistics.StatsGrid do
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
    """
  end
end

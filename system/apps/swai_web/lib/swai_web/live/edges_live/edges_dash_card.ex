defmodule SwaiWeb.EdgesLive.EdgesDashCard do
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
      <div class="grid-container w-full h-24 border rounded-lg shadow-lg overflow-hidden grid grid-cols-2 grid-rows-2 gap-4 p-4">
        <div class="grid-item text-red-800">5 Nodes Connected</div>
        <div class="grid-item text-green-800">10524 Messages/sec</div>
        <div class="grid-item text-blue-800">241 Swarms active</div>
        <div class="grid-item text-orange-800">24187 Users online</div>
      </div>
    """
  end
end

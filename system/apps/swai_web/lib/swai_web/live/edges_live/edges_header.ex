defmodule SwaiWeb.EdgesLive.EdgesHeader do
  use SwaiWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto px-4 py-2">
      <div class="flex flex-wrap justify-start gap-2">
      <p>A global overview of the Macula Mesh</p>
      <div class="grid-container w-full h-15 border rounded-lg shadow-lg overflow-hidden grid grid-cols-4 grid-rows-2 gap-4 p-4">
        <div class="grid-item text-red-400"><%= Enum.uniq_by(@edges, fn it -> it.country end) |> Enum.count() %> Countries covered</div>
        <div class="grid-item text-orange-400">24187 Users online</div>
        <div class="grid-item text-yellow-400"> <%= Enum.uniq_by(@edges, fn it -> it.algorithm_acronym end) |> Enum.count() %> Algorithms supported</div>
        <div class="grid-item text-green-400"><%= Enum.count(@edges) %> Nodes connected</div>
        <div class="grid-item text-blue-400">241 Scapes active</div>
        <div class="grid-item text-indigo-400"><%= "#{@nbr_of_msgs}  Messages/sec" %></div>
      </div>
      </div>
    </div>
    """
  end
end

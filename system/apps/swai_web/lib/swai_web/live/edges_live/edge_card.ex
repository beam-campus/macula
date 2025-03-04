defmodule SwaiWeb.EdgesLive.EdgeCard do
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
    <div class="relative rounded overflow-hidden shadow-lg m-4">
      <div class="absolute inset-0 bg-black opacity-80"></div>
      <div class="rounded overflow-hidden shadow-lg m-1 bg-cover bg-center" style={"background-image: url(" <> @edge.image_url <> ");"}>
        <div class="relative p-4">
          <div class="uppercase tracking-wide text-sm text-red-800 font-semibold">
            <%= @edge.ip_address %>
            <p class="block mt-1 text-sm leading-tight font-normal text-green-200"> <%= "Running #{@edge.stats.nbr_of_agents} agents" %></p>
          </div>
          <p class="block mt-1 text-sm leading-tight font-medium text-white"> <%= @edge.isp %></p>
          <p class="block mt-1 text-sm leading-tight font-medium text-white"> <%= @edge.reverse %></p>
          <p class="mt-2 text-gray-300">
            <%= " #{@edge.flag}   #{@edge.city}, #{@edge.country} " %><br>
            Connected Since: <%= @edge.connected_since %><br>
            <!-- Add other Edge.Init elements here -->
          </p>
        </div>
        </div>
    </div>
    """
  end
end

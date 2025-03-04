defmodule SwaiWeb.ScapeMiniCard do
  @moduledoc """
  The ScapeCard is a live component that renders a card for a Scape.
  """
  use SwaiWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
    }
  end


  attr(:scape, ScapeInit)
  attr(:particles, :list)
  attr(:arena, ArenaInit)
  attr(:hives, :list)

  def scape_minimap(assigns) do
    ~H"""
    <div id={"scape-thumbnail-#{@scape.scape_id}"}
    class="scape-minimap"
    >
    <div class="scape-mini-map-inner">
      <.live_component
        id={"arena-map-#{@scape.scape_id}"}
        module={SwaiWeb.ArenaMapView}
        scape={@scape}
        particles={@particles}
        arena={@arena}
        hives={@hives}
      />
      </div>
    </div>
    """
  end

  attr(:hive, HiveInit)

  defp hive_box(assigns) do
    ~H"""
    <div class="hive-box-container">
      <div class="hive-box-grid border rounded">
      <div>
      <p class={"text-#{@hive.hive_color}-400"}><%= @hive.hive_name %></p>
      <p>Status: <%= @hive.hive_status_string %></p>
      <p>Location: <%= inspect(Map.from_struct(@hive.hexa)) %></p>
      </div>
      <div>
      <p>Swarm: <%= @hive.license_id %></p>
      <p>Pop. Cap: <%= @hive.particles_cap %></p>
      <p>Population: <%= 1000 %></p>
      </div>
      </div>
    </div>
    """
  end

  attr(:scape, ScapeInit)
  attr(:particles, :list)
  attr(:arena, ArenaInit)
  attr(:hives, :list)
  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-row text-white font-mono font-regular text-sm mb-2">
      <%!-- <div id="hive-boxes-div" class="grid grid-cols-1  gap-2">
        <%= for hive <- @hives |> Enum.sort(&(&2.hive_no > &1.hive_no)) do %>
          <.hive_box hive={hive} />
        <% end %>
      </div> --%>
      <div id="scape-mini-map-div" class="relative w-full"> <!-- 16:9 Aspect Ratio -->
        <div class="relative top-0 left-0 w-full h-full">
          <.scape_minimap
          scape={@scape}
          particles={@particles}
          arena={@arena}
          hives={@hives}
          />
        </div>
      </div>
    </div>
    """
  end

end

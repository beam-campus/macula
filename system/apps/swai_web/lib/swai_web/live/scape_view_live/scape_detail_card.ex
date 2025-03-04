defmodule SwaiWeb.ScapeViewLive.ScapeDetailCard do
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

  defp scape_detail_header(assigns) do
    ~H"""
    <div class="px-1 text-white">
      <p class="text-lg font-brand"><%= @scape.scape_name %></p>
    </div>
    """
  end

  attr(:hives, :list)

  defp scape_detail_hives(assigns) do
    ~H"""
    <div class="grid grid-cols-1 md:grid-cols-1 gap-2 mt-1">
      <%= for hive <- @hives do %>
        <.live_component id={"hive-box-#{hive.hive_id}"} module={SwaiWeb.HiveBox} hive={hive} />
      <% end %>
    </div>
    """
  end

  attr(:scape, ScapeInit)
  attr(:particles, :list)
  attr(:arena, ArenaInit)
  attr(:hives, :list)

  def scape_detail_arena(assigns) do
    ~H"""
    <div id={"scape-thumbnail-#{@scape.scape_id}"} class="scape-minimap-container">
      <div class="scape-minimap">
        <div class="scape-minimap-inner">
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
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="scape-detail-card" class="mx-4">
      <.scape_detail_header scape={@scape} />
      <.scape_detail_hives hives={@hives} />
      <.scape_detail_arena scape={@scape} particles={@particles} arena={@arena} hives={@hives} />
    </div>
    """
  end
end

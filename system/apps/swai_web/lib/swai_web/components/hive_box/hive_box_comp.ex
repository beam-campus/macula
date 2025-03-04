defmodule SwaiWeb.HiveBox do
  @moduledoc """
  The HiveBox is a live component that renders a box for a Hive.
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

  @impl true
  def render(assigns) do
    ~H"""
    <div class="hive-box-container">
      <div class="hive-box-grid">
        <div>
          <%= if @hive.license do %>
            <p class={"text-#{@hive.hive_color}-400"}><%= @hive.license.swarm_name %></p>
          <% else %>
            <p class="text-gray-400"><%= @hive.hive_name %></p>
          <% end %>
        </div>
        <div>
          <%= if @hive.license do %>
            <p><%= 1000 %>/<%= @hive.particles_cap %> particles</p>
          <% else %>
            <p><%= 0 %>/<%= @hive.particles_cap %> particles</p>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end

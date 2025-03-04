defmodule SwaiWeb.MarketplaceLive.ModelsSection do
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
    <div id="marketplace-models-section" class="mx-4">
      <div class="px-5 text-white">
        <h2><%= @section_title %></h2>
        <p class="text-sm font-brand"><%= @section_description %></p>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-1 gap-4 mt-3">
        <%= for biotope <- @biotopes do %>
          <.live_component
            id={"section-card-#{biotope.id}"}
            module={SwaiWeb.MarketplaceLive.BiotopeCard}
            biotope={biotope}
            live_action={@live_action}
            current_user={@current_user}
          />
        <% end %>
      </div>
    </div>
    """
  end
end

defmodule SwaiWeb.MarketplaceLive.InitSwarmUserCard do
  use SwaiWeb, :live_component

  alias SwaiWeb.MarketplaceLive.RequestLicenseToSwarmForm
  alias Schema.User, as: User

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="card init-swarm-user-card">
      <div class="card-content">
        <div class="media">
          <div class="media-left">
            <figure class="image is-48x48">
              <img
              src={@user.image_url}
              alt={"#{@user.first_name}'s avatar"}
              class="is-rounded"
              >
            </figure>
          </div>
          <div class="media-content">
            <p class="title is-4"><%= @user.name %></p>
            <p class="subtitle is-6">
              <span class="icon">
                <i class="fas fa-envelope"></i>
              </span>
              <%= @user.email %>
            </p>
          </div>
        </div>
      </div>
      <footer class="card-footer">
      </footer>
    </div>
    """
  end

  def handle_event("open_modal", _, socket) do
    {:noreply, assign(socket, show_modal: true)}
  end
end

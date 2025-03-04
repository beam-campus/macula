defmodule SwaiWeb.UserAvatar do
  @moduledoc """
  The UserAvatar is a live component that renders an avatar for a User.
  """
  use SwaiWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if @avatar do %>
        <img
          src={"https://api.dicebear.com/8.x/bottts/svg?seed=#{@avatar}"}
          alt="Profile Image"
          class={"#{@width} #{@height} round-image-padding"}
        />
      <% else %>
        <img
          src="https://api.dicebear.com/8.x/bottts/svg?seed=guest00000000000000"
          alt="Profile Image"
          class={"#{@width} #{@height} round-image-padding"}
        />
      <% end %>
    </div>
    """
  end
end

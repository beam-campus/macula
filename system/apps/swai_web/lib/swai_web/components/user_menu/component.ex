defmodule SwaiWeb.UserMenu do
  @moduledoc false
  alias Hex.API.User
  use SwaiWeb, :live_component

  alias Schema.User, as: User
  alias Phoenix.LiveView.JS

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  def toggle_dropdown_menu do
    JS.toggle(
      to: "#dropdown_menu",
      in: {
        "transition ease-out duration-300",
        "transform opacity-0 translate-y-[-10%]",
        "transform opacity-100 translate-y-0"
      },
      out: {
        "transition ease-in duration-300",
        "transform opacity-100 translate-y-0",
        "transform opacity-0 translate-y-[-10%]"
      }
    )
  end

  # src="/images/user-image.svg"

  attr :current_user, User

  defp user_button(assigns) do
    ~H"""
    <div>
      <%= if @current_user do %>
        <button
          class="img-down-arrow-user"
          type="button"
          id="user_menu_button"
          phx-click={SwaiWeb.UserMenu.toggle_dropdown_menu()}
        >
          <img
            src={"https://api.dicebear.com/8.x/bottts/svg?seed=#{@current_user.user_alias}"}
            alt="Profile Image"
            class="w-15 h-12 round-image-padding-user"
          />
        </button>
      <% else %>
        <button
          class="img-down-arrow"
          type="button"
          id="user_menu_button"
          phx-click={SwaiWeb.UserMenu.toggle_dropdown_menu()}
        >
          <img
            src="https://api.dicebear.com/8.x/bottts/svg?seed=guest00000000000000"
            alt="Profile Image"
            class="w-15 h-12 round-image-padding"
          />
        </button>
      <% end %>
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.user_button current_user={@current_user} />
      <div
        id="dropdown_menu"
        phx-click-away={SwaiWeb.UserMenu.toggle_dropdown_menu()}
        class="absolute right-0 w-48 py-2 m-2 border border-white rounded-lg shadow-xl dropdown-menu-arrow bg-ltDark"
        hidden="true"
      >
        <.link
          href="/hives"
          class="menu-item"
          role="menuitem"
          tabindex="-1"
          method="get"
          id="user-menu-item-about"
        >
          Macula
        </.link>

        <.link
          href="/marketplace"
          class="border-b border-white border-opacity-50 menu-item"
          role="menuitem"
          tabindex="-1"
          method="get"
          id="user-menu-training-grounds"
        >
          Marketplace
        </.link>

        <%= if @current_user do %>
          <.link
            href="/my_workspace"
            class="menu-item"
            role="menuitem"
            tabindex="-1"
            method="get"
            id="user-menu-workspace"
          >
            My Workspace
          </.link>

          <.link
            href={~p"/users/settings"}
            class="border-b border-white border-opacity-50 menu-item"
            role="menuitem"
            tabindex="-1"
            method="get"
            id="user-menu-item-profile"
          >
            My Profile
          </.link>

          <.link
            href={~p"/users/log_out"}
            class="menu-item"
            role="menuitem"
            tabindex="-1"
            method="delete"
            id="user-menu-item-5"
          >
            Sign out
          </.link>
        <% else %>
          <.link
            href={~p"/users/log_in"}
            class="border-b border-white border-opacity-50 menu-item"
            role="menuitem"
            tabindex="-1"
            method="get"
            id="user-menu-item-100"
          >
            Sign in
          </.link>

          <.link
            href={~p"/users/register"}
            class="menu-item"
            role="menuitem"
            tabindex="-1"
            method="get"
            id="user-menu-item-101"
          >
            Register
          </.link>
        <% end %>
      </div>
    </div>
    """
  end
end

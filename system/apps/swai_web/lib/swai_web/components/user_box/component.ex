defmodule SwaiWeb.UserBox do
  @moduledoc """
  The UserBox is a live component that renders a box for a User.
  """
  use SwaiWeb, :live_component


  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center" id="user_box_wrapper">
      <div class="flex flex-row items-center" id="user_box" style="min-width: fit-content; flex-shrink: 0;">
        <div class="flex-grow">
        <%= if @current_user do %>
          <.live_component
            module={SwaiWeb.BudgetBox}
            id="budget_box"
            current_user={@current_user}
          />
        <% end %>
        </div>
        <div style="flex-shrink: 0;">
        <.live_component
          module={SwaiWeb.UserMenu}
          id="user_menu"
          current_user={@current_user}
        />
        </div>
      </div>
    </div>
    """
  end



end

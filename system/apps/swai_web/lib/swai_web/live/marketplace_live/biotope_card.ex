defmodule SwaiWeb.MarketplaceLive.BiotopeCard do
  @moduledoc """
  The live component for the biotope card.
  """
  use SwaiWeb, :live_component
  alias Schema.Biotope, as: Biotope
  alias Swai.Defaults, as: Limits

  require Logger

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  attr :biotope, Biotope

  defp card_header(assigns) do
    ~H"""
    <div class="section-card-header">
      <img
        class="h-24 w-full object-cover opacity-80 rounded radius-10"
        src={"#{@biotope.image_url}"}
        alt={"#{@biotope.id}"}
      />
      <div class="flex flex-row text-swBrand-dark pt-2 font-regular">
        <p><%= @biotope.name %> [<%= @biotope.algorithm_name %>]</p>
        <p class="font-regular uppercase text-swBrand-light ml-auto" id="biotope_theme">
          <%= @biotope.theme %>
        </p>
      </div>
    </div>
    """
  end

  attr :biotope, Biotope

  defp card_body(assigns) do
    ~H"""
    <div class="section-card-body">
      <p class="font-xs text-base">
        <%= @biotope.description %>
      </p>
      <p class="mt-1 text-base">
        <%= @biotope.objectives %>
      </p>
    </div>
    """
  end

  attr :current_user, Schema.User
  attr :biotope, Biotope

  defp user_buttons(assigns) do
    ~H"""
    <div class="button-row">
      <%= if @current_user.budget >= Limits.standard_cost_in_tokens() do %>
        <.link patch={~p"/marketplace/start-swarm/#{@biotope.id}"}>
          <.button>Launch this Swarm!</.button>
        </.link>
      <% else %>
        <.link patch={~p"/users/add_tokens"}>
          <.button>Insufficient Tokens</.button>
        </.link>
      <% end %>
    </div>
    """
  end

  attr :biotope, Biotope
  attr :current_user, Schema.User

  defp card_footer(assigns) do
    ~H"""
    <div class="button-row mt-1 flex justify-between">
      <%= if @biotope.is_active? do %>
        <%= if @current_user do %>
          <.user_buttons biotope={@biotope} current_user={@current_user} />
        <% else %>
          <.link patch={~p"/users/log_in"}>
            <.button>Log in to Launch this Swarm!</.button>
          </.link>
        <% end %>
        <%!-- <button class="btn-dashboard">Dashboard</button> --%>
      <% else %>
        <.button class="btn-sponsor">Sponsor this Model</.button>
      <% end %>
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class={"section-card " <> active_class(@biotope.is_active?)}>
      <.card_header biotope={@biotope} />
      <.card_body biotope={@biotope} />
      <.card_footer biotope={@biotope} current_user={@current_user} />
    </div>
    """
  end

  defp active_class(true), do: "active-biotope"
  defp active_class(false), do: "inactive-biotope"
end

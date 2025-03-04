defmodule SwaiWeb.Layouts.OldHeader do
  @moduledoc false
  use SwaiWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="border-b-[1px] border-gray-700 w-full">
      <header class="header-sticky flex items-center justify-between">
        <!-- Left side of toolbar -->
        <div class="flex flex-row items-center">
          <a href={~p"/"}>
            <img src="/images/swai-logo-nobg.svg" alt="swai logo" width="200" />
          </a>
          <p class="text-swBrand-dark text-2xl font-brand pl-5"><%= assigns[:page_title] %></p>
          <!-- <div class="font-brand text-xs text-white pl-5" id="bar-disclaimer"> -->
          <!--   <span> -->
          <!--     DISCLAIMER: This site is WiP! Estimated launch date: 15.09.2024.<br /> -->
          <!--     If you want to support our work, please consider -->
          <!--     <a -->
          <!--       href="https://www.buymeacoffee.com/beamologist" -->
          <!--       class="text-ltOrange-light hover:underline" -->
          <!--     > -->
          <!--       buying us a coffee -->
          <!--     </a> -->
          <!--   </span> -->
          <!-- </div> -->
        </div>
        <!-- Right side of toolbar -->
        <div class="flex items-center flex-row">
          <.live_component id="user_box" module={SwaiWeb.UserBox} current_user={@current_user} />
        </div>
      </header>
    </div>
    """
  end
end

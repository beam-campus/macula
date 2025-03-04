defmodule SwaiWeb.Layouts.OldFooter do
  use SwaiWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <footer class="footer-sticky w-full pl-10">
      <div class="border-t-[1px] border-gray-700 h-full">
        <div class="flex items-center pb-10 mt-2 space-x-2">
          <img src="/images/discomco-logo.png" alt="DisComCo Logo image-only" class="h-7 w-7" />
          <p class="text-sm text-white font-brand font-regular">
            with ❤️ from
            <a href="https://discomco.pl" class="font-regular hover:underline">DisComCo</a>
          </p>
          <div class="px-4 space-x-3 text-xs text-ltOrange-light font-brand">
            <a href={~p"/mission"} class="hover:underline">
              Our Mission
            </a>
            <a href={~p"/terms_of_service"} class="hover:underline">
              Terms
            </a>
            <a href={~p"/"} class="hover:underline">
              Privacy
            </a>
            <a href="https://github.com/beam-campus/swai" class="hover:underline">
              GitHub
            </a>
          </div>
        </div>
      </div>
    </footer>
    """
  end
end

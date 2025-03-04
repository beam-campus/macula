defmodule SwaiWeb.BiotopeLive.Show do
  use SwaiWeb, :live_view

  alias Swai.Biotopes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:biotope, Biotopes.get_biotope!(id))}
  end

  defp page_title(:show), do: "Show Biotope"
  defp page_title(:edit), do: "Edit Biotope"
end

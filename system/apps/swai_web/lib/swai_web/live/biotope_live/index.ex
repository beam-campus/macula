defmodule SwaiWeb.BiotopeLive.Index do
  use SwaiWeb, :live_view

  alias Swai.Biotopes
  alias Schema.Biotope, as: Biotope

  alias Edges.Service, as: Edges

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        {:ok,
         socket
         |> assign(
           edges: Edges.get_all(),
           now: DateTime.utc_now()
         )
         |> stream(:biotopes, Biotopes.list_biotopes())}

      false ->
        {:ok,
         socket
         |> assign(
           edges: Edges.get_all(),
           now: DateTime.utc_now()
         )
         |> stream(:biotopes, Biotopes.list_biotopes())}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Biotope")
    |> assign(:biotope, Biotopes.get_biotope!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Biotope")
    |> assign(:biotope, %Biotope{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Biotopes")
    |> assign(:biotope, nil)
  end

  @impl true
  def handle_info({SwaiWeb.BiotopeLive.FormComponent, {:saved, biotope}}, socket) do
    {:noreply, stream_insert(socket, :biotopes, biotope)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    biotope = Biotopes.get_biotope!(id)
    {:ok, _} = Biotopes.delete_biotope(biotope)

    {:noreply, stream_delete(socket, :biotopes, biotope)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
    Listing Biotopes
    <:actions>
    <.link patch={~p"/biotopes/new"}>
      <.button>New Biotope</.button>
    </.link>
    </:actions>
    </.header>

    <.table
    id="biotopes"
    rows={@streams.biotopes}
    row_click={fn {_id, biotope} -> JS.navigate(~p"/biotopes/#{biotope}") end}
    >
    <:col :let={{_id, biotope}} label="Name"><%= biotope.name %></:col>
    <:col :let={{_id, biotope}} label="Description"><%= biotope.description %></:col>
    <:col :let={{_id, biotope}} label="Image url"><%= biotope.image_url %></:col>
    <:col :let={{_id, biotope}} label="Theme"><%= biotope.theme %></:col>
    <:col :let={{_id, biotope}} label="Tags"><%= biotope.tags %></:col>
    <:action :let={{_id, biotope}}>
    <div class="sr-only">
      <.link navigate={~p"/biotopes/#{biotope}"}>Show</.link>
    </div>
    <.link patch={~p"/biotopes/#{biotope}/edit"}>Edit</.link>
    </:action>
    <:action :let={{id, biotope}}>
    <.link
      phx-click={JS.push("delete", value: %{id: biotope.id}) |> hide("##{id}")}
      data-confirm="Are you sure?"
    >
      Delete
    </.link>
    </:action>
    </.table>

    <.modal :if={@live_action in [:new, :edit]} id="biotope-modal" show on_cancel={JS.patch(~p"/biotopes")}>
    <.live_component
    module={SwaiWeb.BiotopeLive.FormComponent}
    id={@biotope.id || :new}
    title={@page_title}
    action={@live_action}
    biotope={@biotope}
    patch={~p"/biotopes"}
    />
    </.modal>
    """
  end
end

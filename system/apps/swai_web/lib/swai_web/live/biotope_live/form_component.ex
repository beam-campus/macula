defmodule SwaiWeb.BiotopeLive.FormComponent do
  use SwaiWeb, :live_component

  alias Swai.Biotopes

  @impl true
  def update(%{biotope: biotope} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Biotopes.change_biotope(biotope))
     end)}
  end

  @impl true
  def handle_event("validate", %{"biotope" => biotope_params}, socket) do
    changeset = Biotopes.change_biotope(socket.assigns.biotope, biotope_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"biotope" => biotope_params}, socket) do
    save_biotope(socket, socket.assigns.action, biotope_params)
  end

  defp save_biotope(socket, :edit, biotope_params) do
    case Biotopes.update_biotope(socket.assigns.biotope, biotope_params) do
      {:ok, biotope} ->
        notify_parent({:saved, biotope})

        {:noreply,
         socket
         |> put_flash(:info, "Biotope updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_biotope(socket, :new, biotope_params) do
    case Biotopes.create_biotope(biotope_params) do
      {:ok, biotope} ->
        notify_parent({:saved, biotope})

        {:noreply,
         socket
         |> put_flash(:info, "Biotope created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage biotope records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="biotope-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:image_url]} type="text" label="Image url" />
        <.input field={@form[:theme]} type="text" label="Theme" />
        <.input field={@form[:tags]} type="text" label="Tags" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Biotope</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end




end

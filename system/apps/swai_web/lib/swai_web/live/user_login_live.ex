defmodule SwaiWeb.UserLoginLive do
  use SwaiWeb, :live_view

  alias Edges.Service,
    as: Edges

  @impl true
  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")

    {:ok,
     socket
     |> assign(
       page_title: "Sign in",
       form: form,
       edges: Edges.get_all()
     ), temporary_assigns: [form: form]}
  end

  @impl true
  def handle_info(_msg, socket) do
    {:noreply, socket |> assign(edges: Edges.get_all())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center bg-gray-100 m-10 py-10 px-5 bg-white bg-opacity-50 rounded-lg shadow-xl" id="user_login">
    <div class="max-w-md px-8 py-6 bg-white rounded-lg shadow-lg" id="login_form">
          <.simple_form
            for={@form}
            id="login_form"
            action={~p"/users/log_in"}
            phx-update="ignore"
            class="space-y-6">
              <.input
                field={@form[:email]}
                type="email"
                label="Email"
                required
                class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-light"
              />
              <.input
                field={@form[:password]}
                type="password"
                label="Password"
                required
                class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-light"
              />

              <:actions>
                <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
                <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
                  Forgot your password?
                </.link>
              </:actions>


              <:actions>
                <.button
                phx-disable-with="Signing in..."
                class="w-full">
                  Sign in
                </.button>
              </:actions>
          </.simple_form>

          <div class="justify-center" id="no_account_yet">
          Don't have an account?
          <.link
            navigate={~p"/users/register"}
            class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
    </div>

    </div>
    </div>
    """
  end
end

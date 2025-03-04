defmodule SwaiWeb.UserRegistrationLive do
  use SwaiWeb, :live_view

  alias Swai.Accounts

  alias Schema.User, as: User

  alias Edges.Service, as: Edges

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    changeset
    |> Accounts.with_random_alias()

    # Logger.debug("Changeset: #{inspect(changeset)}")

    case connected?(socket) do
      true ->
        {
          :ok,
          socket
          |> assign(
            page_title: "User Registration",
            trigger_submit: false,
            check_errors: false,
            edges: Edges.get_all()
          )
          |> assign_form(changeset),
          temporary_assigns: [form: nil]
        }

      false ->
        {:ok,
         socket
         |> assign(
           page_title: "User Registration",
           trigger_submit: false,
           check_errors: false,
           edges: []
         )
         |> assign_form(changeset), temporary_assigns: [form: nil]}
    end
  end

  @impl true
  def handle_info(_msg, socket) do
    {
      :noreply,
      socket
      |> assign(edges: Edges.get_all())
    }
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    # Logger.debug("Saving User params: #{inspect(user_params)}")

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset =
          Accounts.change_user_registration(user)
          |> Ecto.Changeset.delete_change(:password_confirmation)

        # Logger.debug("Changeset: #{inspect(changeset)}")

        {
          :noreply,
          socket
          |> assign(trigger_submit: true)
          |> assign_form(changeset)
          |> put_flash(:info, "Please check your email to confirm your account.")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Error: #{inspect(changeset)}")

        {
          :noreply,
          socket
          |> assign(check_errors: true)
          |> assign_form(changeset)
          |> put_flash(:error, changeset_errors_to_string(changeset))
        }
    end
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp changeset_errors_to_string(changeset),
    do:
      Enum.map_join(
        changeset.errors,
        fn {_field, {message, _}} ->
          "#{message}"
        end,
        ", \n"
      )

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      class="flex flex-col items-center bg-gray-100 m-10 py-10 px-5 bg-white bg-opacity-50 rounded-lg shadow-xl"
      id="user_login"
    >
      <div class="max-w-md px-8 py-6 bg-white rounded-lg shadow-lg" id="login_form">
        <.header>
          Register a new user account
        </.header>
        <.simple_form
          for={@form}
          id="registration_form"
          phx-change="validate"
          phx-submit="save"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
        >
          <.input field={@form[:email]} type="email" label="Email*" required />
          <.input field={@form[:user_alias]} type="text" label="Alias* (will be visible)" required />
          <.input field={@form[:password]} type="password" label="Password*" required />
          <.input
            field={@form[:password_confirmation]}
            type="password"
            label="Confirm password*"
            required
          />

          <:actions>
            <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
          </:actions>
        </.simple_form>

        <div class="justify-center">
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Sign in
          </.link>
          to your account now.
        </div>
      </div>
    </div>
    """
  end
end

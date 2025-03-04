defmodule SwaiWeb.MarketplaceLive.Index do
  @moduledoc """
  The live view for the training grounds index page.
  """
  use SwaiWeb, :live_view

  alias Swai.Defaults, as: Limits
  alias Schema.SwarmLicense.Status, as: LicenseStatus
  alias Edges.Service, as: Edges
  alias Swai.Biotopes, as: Biotopes
  alias Schema.SwarmLicense, as: SwarmLicense
  alias TrainSwarmProc, as: TrainSwarmProc

  require Logger

  defp get_swarm_name(user_alias, biotope_name) do
    "#{user_alias}_#{biotope_name}_#{MnemonicSlugs.generate_slug(2)}"
    |> String.replace(" ", "_")
    |> String.replace("-", "_")
    |> String.downcase()
  end

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        biotopes = Biotopes.list_biotopes()
        active_models = biotopes |> Enum.filter(& &1.is_active?)
        inactive_models = biotopes |> Enum.reject(& &1.is_active?)

        {
          :ok,
          socket
          |> assign(
            edges: Edges.get_all(),
            active_models: active_models,
            inactive_models: inactive_models,
            now: DateTime.utc_now(),
            page_title: "Marketplace",
            show_init_swarm_modal: false,
            biotope: nil,
            live_action: :index
          )
        }

      false ->
        {:ok,
         socket
         |> assign(
           edges: Edges.get_all(),
           active_models: [],
           inactive_models: [],
           now: DateTime.utc_now(),
           page_title: "Marketplace",
           show_init_swarm_modal: false,
           biotope: nil,
           live_action: :index
         )}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {
      :noreply,
      socket
      |> apply_action(socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Marketplace")
    |> assign(:swarm_license, nil)
    |> assign(:biotope, nil)
  end

  defp apply_action(socket, :start_swarm, params) do
    Logger.debug("Applying Action :start_swarm => #{inspect(params)}")

    %{
      id: biotope_id,
      name: biotope_name
    } =
      current_biotope =
      socket.assigns.active_models
      |> Enum.find(fn it -> it.id == params["biotope_id"] end)

    %{
      id: user_id,
      user_alias: user_alias,
      budget: available_tokens
    } = socket.assigns.current_user

    seed = %SwarmLicense{
      license_id: UUID.uuid4(),
      status: LicenseStatus.unknown(),
      user_id: user_id,
      user_alias: user_alias,
      cost_in_tokens: Limits.standard_cost_in_tokens(),
      available_tokens: available_tokens,
      swarm_name: get_swarm_name(user_alias, biotope_name),
      biotope_id: biotope_id,
      biotope_name: biotope_name
    }

    case SwarmLicense.from_map(seed, current_biotope) do
      {:ok, license} ->
        case TrainSwarmProc.initialize(license) do
          :ok ->
            socket
            |> assign(
              page_title: "Start a Swarm",
              swarm_license: license,
              biotope: current_biotope,
              live_action: :overview
            )
            |> redirect(to: ~p"/my_workspace")
            |> put_flash(:info, "Swarm Queued for Launch")

          _msg ->
            socket
        end

      {:error, changeset} ->
        Logger.error("Error creating swarm license: #{inspect(changeset)}")
        socket
    end
  end

  @impl true
  def handle_info(
        {SwaiWeb.MarketplaceLive.RequestLicenseToSwarmForm,
         {:swarm_license_submitted, _license_request}},
        socket
      ) do
    {:noreply,
     socket
     |> assign(:live_action, :overview)
     |> redirect(to: ~p"/my_workspace")
     |> put_flash(:info, "License Request Submitted")}
  end

  @impl true
  def handle_info({:present_license, license}, socket) do
    case TrainSwarmProc.initialize(license) do
      :ok ->
        {
          :noreply,
          socket
          |> assign(:swarm_license, license)
          |> assign(:live_action, :overview)
        }

      _msg ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:no_user}, socket) do
    {
      :noreply,
      socket
      |> put_flash(:warning, "You must be logged in to access this page.")
      |> redirect(to: ~p"/users/log_in")
    }
  end

  @impl true
  def handle_info(msg, socket) do
    Logger.debug("MarketplaceLive.Index.handle_info: #{inspect(msg)}")
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="marketplace-view" class="flex flex-col h-full">
      <section class="mt-11">
        <.live_component
          id="active-models-section"
          current_user={@current_user}
          live_action={@live_action}
          module={SwaiWeb.MarketplaceLive.ModelsSection}
          edges={@edges}
          biotopes={@active_models}
          now={@now}
          section_title="Available Ecosystems"
          section_description="
          Please do keep in mind that right now, only one swarm can be trained on the free plan."
        />
      </section>
      <section class="mt-20">
        <.live_component
          id="inactive-models-section"
          current_user={@current_user}
          live_action={@live_action}
          module={SwaiWeb.MarketplaceLive.ModelsSection}
          edges={@edges}
          biotopes={@inactive_models}
          now={@now}
          section_title="Coming soon..."
          section_description="Do you want to see these models to become available for your research or entertainment?
          Then do consider supporting our efforts by buying us a coffee or by becoming part of a community that
          is dedicated to this different form of AI!"
        />
      </section>
      <section id="dummy-section" class="pt-15" style="height: 100px;">
        <div class="flex justify-center items-center" style="height: 150px;">
          <p class="text-lg text-gray-500"></p>
        </div>
      </section>
    </div>
    <!-- .modal
      :if={@live_action in [:start_swarm, :request_license, :new]}
      id="request-license-modal-dialog"
      show
      on_cancel={JS.patch(~p"/marketplace")}
    >
      <.live_component
        module={SwaiWeb.MarketplaceLive.RequestLicenseToSwarmForm}
        id="request-license-modal-dialog"
        title={"Request a License to Swarm for: #{@biotope.name}"}
        action={@live_action}
        biotope={@biotope}
        current_user={@current_user}
        patch={~p"/swarm_licenses"}
        edges={@edges}
        swarm_license={@swarm_license}
      />
    </.modal -->
    """
  end
end

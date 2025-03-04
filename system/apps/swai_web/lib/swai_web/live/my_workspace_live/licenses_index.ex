defmodule SwaiWeb.MyWorkspaceLive.Index do
  @moduledoc """
  The live view for the workspace index page.
  """
  alias Swai.Accounts
  use SwaiWeb, :live_view

  alias Edge.Facts, as: EdgeFacts
  alias Edges.Service, as: Edges
  alias Hive.Facts, as: HiveFacts
  alias License.Facts, as: LicenseFacts
  alias Licenses.Service, as: Licenses
  alias Phoenix.PubSub, as: PubSub
  alias Scape.Facts, as: ScapeFacts
  alias Schema.SwarmLicense, as: SwarmLicense

  @licenses_cache_facts LicenseFacts.licenses_cache_facts()
  @scapes_cache_facts ScapeFacts.scapes_cache_facts()
  @edges_cache_facts EdgeFacts.edges_cache_facts()
  @hives_cache_facts HiveFacts.hives_cache_facts()



  require Logger

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    case connected?(socket) do
      true ->
        # trainings = Workspace.get_swarm_licenses_by_user_id(current_user.id)

        Swai.PubSub
        |> PubSub.subscribe(@licenses_cache_facts)

        Swai.PubSub
        |> PubSub.subscribe(@scapes_cache_facts)

        Swai.PubSub
        |> PubSub.subscribe(@edges_cache_facts)

        Swai.PubSub
        |> PubSub.subscribe(@hives_cache_facts)

        {
          :ok,
          socket
          |> assign(
            page_title: "Workspace",
            edges: Edges.get_all(),
            now: DateTime.utc_now(),
            licenses: Licenses.get_all_for_user(current_user.id)
          )
        }

      false ->
        {:ok,
         socket
         |> assign(
           page_title: "Workspace",
           edges: [],
           now: DateTime.utc_now(),
           licenses: []
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
    |> assign(:page_title, "Workspace")
  end



  @impl true
  def handle_info({:licenses, {_evt, %SwarmLicense{user_id: the_user}}}, socket) do
    if the_user == socket.assigns.current_user.id do
      new_user = Accounts.get_user!(the_user)

      licenses = Licenses.get_all_for_user(socket.assigns.current_user.id)

      {
        :noreply,
        socket
        |> assign(
          current_user: new_user,
          licenses: licenses
        )
      }
    else
      {:noreply, socket}
    end
  end

  ########################### SUBSCRIPTIONS FALLTHROUGH ############################
  @impl true
  def handle_info(_msg, socket) do
    licenses = Licenses.get_all_for_user(socket.assigns.current_user.id)
    {
      :noreply,
      socket
      |> assign(licenses: licenses)
    }

    {:noreply, socket}
  end

  
  @impl true
  def render(assigns) do
    ~H"""
    <div id="workspace-view" class="flex flex-col h-full">
      <section class="mt-11">
        <.live_component
          id="active-swarms-section"
          current_user={@current_user}
          live_action={@live_action}
          module={SwaiWeb.MyWorkspaceLive.SwarmLicensesSection}
          edges={@edges}
          licenses={@licenses}
          now={@now}
          section_title="My Swarm Licenses"
          section_description="This is a list of all the Swarm Licenses you have created."
        />
      </section>
      <section id="dummy-section" class="pt-15" style="height: 100px;">
        <div class="flex justify-center items-center" style="height: 150px;">
          <p class="text-lg text-gray-500"></p>
        </div>
      </section>
    </div>
    """
  end
end

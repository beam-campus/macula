defmodule SwaiWeb.ScapeViewLive.Index do
  @moduledoc """
  The live view for the Scape view page.
  """
  use SwaiWeb, :live_view

  alias Phoenix.PubSub, as: PubSub

  alias Arenas.Service, as: Arenas
  alias Edges.Service, as: Edges
  alias Hives.Service, as: Hives
  alias Scapes.Service, as: Scapes
  alias Particles.Service, as: Particles

  alias Scape.Init, as: ScapeInit

  alias License.Facts, as: LicenseFacts
  alias Arena.Facts, as: ArenaFacts
  alias Hive.Facts, as: HiveFacts
  alias Particle.Facts, as: ParticleFacts

  @licenses_cache_facts LicenseFacts.licenses_cache_facts()
  @arenas_cache_facts ArenaFacts.arenas_cache_facts()
  @hives_cache_facts HiveFacts.hives_cache_facts()
  @particles_cache_facts ParticleFacts.particles_cache_facts()

  defp do_refresh(socket, scape_id) do
    %ScapeInit{
      edge_id: edge_id,
      scape_name: scape_name
    } = scape = Scapes.get_by_id!(scape_id)

    edge = Edges.get_by_id!(edge_id)
    arena = Arenas.get_for_scape!(scape_id)
    particles = Particles.get_for_scape!(scape_id)
    hives = Hives.get_for_scape!(scape_id)

    socket
    |> assign(
      scape_id: scape_id,
      edge: edge,
      scape: scape,
      page_title: "Scape: #{scape_name}",
      now: DateTime.utc_now(),
      arena: arena,
      hives: hives,
      particles: particles
    )
  end

  @impl true
  def mount(params, _session, socket) do
    scape_id = Map.get(params, "scape_id")

    Swai.PubSub
    |> PubSub.subscribe(@licenses_cache_facts)

    Swai.PubSub
    |> PubSub.subscribe(@arenas_cache_facts)

    Swai.PubSub
    |> PubSub.subscribe(@hives_cache_facts)

    Swai.PubSub
    |> PubSub.subscribe(@particles_cache_facts)

    {
      :ok,
      socket
      |> do_refresh(scape_id)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {
      :noreply,
      socket
      |> apply_action(socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :view, params) do
    scape_id = Map.get(params, "scape_id")

    socket
    |> do_refresh(scape_id)
  end

  @impl true
  def handle_info({:particles, _}, socket) do
    scape_id = socket.assigns.scape_id

    {
      :noreply,
      socket
      |> do_refresh(scape_id)
    }
  end

  ############# SUBSCRIPTIONS FALLTHROUGH #############
  @impl true
  def handle_info(_msg, socket) do
    scape_id = socket.assigns.scape_id
    {
      :noreply,
      socket
      |> do_refresh(scape_id)
    }
  end

  ############## RENDERING ##############
  @impl true
  def render(assigns) do
    ~H"""
    <div id="workspace-view" class="flex flex-col h-full">
      <section class="mt-11">
        <.live_component
          id="active-swarms-section"
          current_user={@current_user}
          live_action={@live_action}
          module={SwaiWeb.ScapeViewLive.ScapeDetailCard}
          scape={@scape}
          arena={@arena}
          hives={@hives}
          particles={@particles}
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

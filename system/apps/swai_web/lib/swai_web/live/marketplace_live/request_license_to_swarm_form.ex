defmodule SwaiWeb.MarketplaceLive.RequestLicenseToSwarmForm do
  alias Scape.Boundaries
  alias Schema.Vector
  use SwaiWeb, :live_component

  alias Schema.SwarmLicense, as: SwarmLicense

  alias MnemonicSlugs, as: MnemonicSlugs
  alias TrainSwarmProc, as: TrainSwarmProc
  alias Scape.Boundaries, as: Boundaries

  require Logger

  @all_fields [
    :license_id,
    :status,
    :status_string,
    :user_id,
    :algorithm_id,
    :algorithm_name,
    :algorithm_acronym,
    :biotope_id,
    :biotope_name,
    :image_url,
    :theme,
    :tags,
    :swarm_id,
    :swarm_name,
    :swarm_size,
    :swarm_time_min,
    :cost_in_tokens,
    :tokens_used,
    :run_time_sec,
    :available_tokens,
    :tokens_balance,
    :reason,
    :additional_info,
    :instructions,
    :scape_id,
    :edge_id,
    :dimensions,
    :edge,
    :boundaries
  ]

  @agg_id "agg_id"
  @form_data "swarm_license"

  @license_id "license_id"
  @user_id "user_id"
  @algorithm_id "algorithm_id"
  @algorithm_name "algorithm_name"
  @algorithm_acronym "algorithm_acronym"
  @biotope_id "biotope_id"
  @biotope_name "biotope_name"
  @image_url "image_url"
  @theme "theme"
  @tags "tags"
  @swarm_id "swarm_id"
  @swarm_name "swarm_name"
  @available_tokens "available_tokens"
  @dimensions "dimensions"
  @boundaries "boundaries"

  defp generate_swarm_name(prefix, nbr_of_slugs) do
    "#{prefix}_#{MnemonicSlugs.generate_slug(nbr_of_slugs)}"
    |> String.downcase()
    |> String.replace("-", "_")
    |> String.replace(" ", "_")
  end

  @impl true
  def update(assigns, socket) do
    prefix = "#{assigns.current_user.user_alias}_#{assigns.biotope.name}"

    map = %{
      @license_id => "temporary_id",
      @user_id => assigns.current_user.id,
      @biotope_id => assigns.biotope.id,
      @biotope_name => assigns.biotope.name,
      @image_url => assigns.biotope.image_url,
      @theme => assigns.biotope.theme,
      @tags => assigns.biotope.tags,
      @algorithm_id => assigns.biotope.algorithm_id,
      @algorithm_acronym => assigns.biotope.algorithm_acronym,
      @algorithm_name => assigns.biotope.algorithm_name,
      @swarm_id => UUID.uuid4(),
      @swarm_name => generate_swarm_name(prefix, 2),
      @available_tokens => assigns.current_user.budget,
      @dimensions => Vector.default_map_dimensions(),
      @boundaries => %Boundaries{}
    }

    lr_changes =
      %SwarmLicense{}
      |> TrainSwarmProc.change_swarm_license(map)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(trigger_submit: false)
      |> assign(check_errors: true)
      |> assign_form(lr_changes)
    }
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: @form_data)

    if changeset.valid? do
      socket
      |> assign(form: form, check_errors: false)
    else
      socket
      |> assign(form: form)
    end
  end

  ############## SUBMISSIONS ####################
  @impl true
  def handle_event("submit_lr", %{@form_data => source} = _license_params, socket) do
    agg_id = UUID.uuid4()

    dimensions =
      Vector.default_map_dimensions()
      |> Map.from_struct()

    boundararies =
      Map.from_struct(%Boundaries{})

    enriched_params =
      source
      |> Map.put(@agg_id, agg_id)
      |> Map.put(@license_id, agg_id)
      |> Map.put(@swarm_id, UUID.uuid4())
      |> Map.put(@user_id, socket.assigns.current_user.id)
      |> Map.put(@biotope_id, socket.assigns.biotope.id)
      |> Map.put(@biotope_name, socket.assigns.biotope.name)
      |> Map.put(@image_url, socket.assigns.biotope.image_url)
      |> Map.put(@theme, socket.assigns.biotope.theme)
      |> Map.put(@tags, socket.assigns.biotope.tags)
      |> Map.put(@algorithm_id, socket.assigns.biotope.algorithm_id)
      |> Map.put(@algorithm_acronym, socket.assigns.biotope.algorithm_acronym)
      |> Map.put(@algorithm_name, socket.assigns.biotope.algorithm_name)
      |> Map.put(@available_tokens, socket.assigns.current_user.budget)
      |> Map.put(@dimensions, dimensions)
      |> Map.put(@boundaries, boundararies)

    case TrainSwarmProc.initialize(enriched_params) do
      :ok ->
        notify_parent({:swarm_license_submitted, enriched_params})
        {:noreply, socket}

      _msg ->
        {:noreply, socket}
    end

    {:noreply, socket}
  end

  ################## VALIDATION ##################
  @impl true
  def handle_event("validate_lr", %{@form_data => form_data}, socket) do
    changeset =
      socket.assigns.swarm_license
      |> TrainSwarmProc.change_swarm_license(form_data)
      |> Map.put(:action, :validate)

    {
      :noreply,
      socket
      |> assign_form(changeset)
    }
  end

  ################## CLOSING ##################
  @impl true
  def handle_event("close_modal", _params, socket) do
    {
      :noreply,
      socket
      |> assign(:show_init_swarm_modal, false)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          A 'License to Swarm' represents a reservation for a slot to evolve your swarm.
          It is automatically activated when your budget (<strong><%= @current_user.budget %>👾</strong>) allows it.
          <br />
          <%= if @current_user.budget - @form[:cost_in_tokens].value < 0  do %>
            <strong class="text-red-500">The cost of a license for this configuration is <%= @form[:cost_in_tokens].value %>👾</strong>.
          <% else %>
            <strong class="text-green-500">The cost of a license for this configuration is <%= @form[:cost_in_tokens].value %>👾</strong>.
          <% end %>
        </:subtitle>
      </.header>
      <.simple_form
        for={@form}
        class="modal-content"
        id="license_request_form"
        phx-target={@myself}
        phx-submit="submit_lr"
        phx-change="validate_lr"
        phx-trigger-action={@trigger_submit}
        method="post"
      >
        <.input
          class="form-control"
          label="Swarm Name"
          type="text"
          field={@form[:swarm_name]}
          required
        />
        <.input
          class="form-control"
          label="Swarm Size"
          type="number"
          pattern="\\d*"
          step="1"
          field={@form[:swarm_size]}
          required
          readonly
        />
        <.input
          class="form-control"
          label="Swarming Time in Minutes"
          type="number"
          pattern="\\d*"
          step="1"
          field={@form[:swarm_time_min]}
          required
          readonly
        />
        <div class="mt-3">
          <.button phx-disable-with="Requesting License...">Submit your License Request</.button>
        </div>
      </.simple_form>
      <button class="modal-close is-large" aria-label="close" phx-click="close_modal"></button>
    </div>
    """
  end
end

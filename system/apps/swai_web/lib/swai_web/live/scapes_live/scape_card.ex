defmodule SwaiWeb.ScapesLive.ScapeCard do
  use SwaiWeb, :live_component

  @moduledoc """
  The live component for the scape card.
  """

  alias Scape.Init, as: ScapeInit

  @all_fields [
    :id,
    :edge_id,
    :name,
    :license_id,
    :swarm_id,
    :swarm_name,
    :swarm_size,
    :swarm_time_min,
    :user_id,
    :biotope_id,
    :algorithm_id,
    :algorithm_acronym,
    :dimensions,
  ]


  @impl true
  def update(assigns, socket) do
    {
      :ok,
     socket
     |> assign(assigns)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%= %ScapeInit{} = item = @scape %>
    <div class="rounded overflow-hidden shadow-lg m-4 bg-cover bg-center" style={"background-image: url(" <> @scape.image_url <> ");"}>
    </div>
    """
  end
end

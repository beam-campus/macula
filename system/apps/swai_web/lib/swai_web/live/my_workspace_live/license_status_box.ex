defmodule SwaiWeb.LicenseStatusBox do
  @moduledoc """
  The LicenseStatusBox is a live component that renders a box for a License.
  """
  use SwaiWeb, :live_component

  alias Schema.SwarmLicense, as: License
  alias Schema.SwarmLicense.Status, as: Status

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
    }
  end

  attr(:license, License)

  defp license_box(assigns) do
    ~H"""
    <div>
      <div class="flex flex-row text-swBrand-dark font-regular mb-2">
        <p><%= @license.swarm_name %> [<%= @license.algorithm_name %>]</p>
        <p class="font-regular uppercase text-swBrand-light ml-auto" id="license_theme">
          <%= @license.theme %>
        </p>
      </div>
      <div>
        <img
          class="h-24 w-full object-cover opacity-80 rounded radius-10"
          src={"#{@license.image_url}"}
          alt={"#{@license.biotope_id}"}
        />
      </div>
    </div>
    """
  end

  # @impl true
  # def render(assigns) do
  #   ~H"""
  #   <div>
  #     <.license_box license={@license} />
  #     <div class="gap-1 mb-auto"></div>
  #     <div class="flex flex-row justify-between items-center text-white font-regular text-xs gap-1 mb-auto">
  #       <%= if @license.edge do %>
  #         <%= if @license.scape_id do %>
  #           <div id={"btn-observe-#{UUID.uuid4()}"} class="ml-2 mb-2">
  #             <.link patch={~p"/scape/#{@scape_id}"}>
  #               <.button>
  #                 <p>Observe <%= "\"#{@license.scape_name}\"" %></p>
  #               </.button>
  #             </.link>
  #           </div>
  #         <% end %>
  #       <% end %>
  #       <div class="flex flex-row items-center ml-auto">
  #         <%= for status <- Status.to_list(@license.status) do %>
  #           <div class={"badge rounded border m-1 p-1 #{status}-status"}><%= status %></div>
  #         <% end %>
  #       </div>
  #     </div>
  #   </div>
  #   """
  # end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.license_box license={@license} />
      <div></div>
      <div class="flex flex-row justify-between items-center text-white font-regular text-xs gap-1 mt-auto">
        <%= if @license.edge do %>
          <div class="flex flex-row items-center">
            <%= if @license.edge.is_container do %>
              <img src={~p"/images/docker-mark.svg"} alt="Node Image" class="docker-image" />
            <% else %>
              <img src={~p"/images/erlang-mark.svg"} alt="Node Image" class="erlang-image" />
            <% end %>
            <img src={"#{@license.edge.flag_svg}"} alt="Node Image" class="edge-image ml-2" />
            <div class="edge-details ml-2">
              <p class="font-regular text-white text-lg">
                <%= @license.edge.city %>, <%= @license.edge.country %>
              </p>
            </div>
            <%= if @license.scape_id do %>
              <div id={"btn-observe-#{UUID.uuid4()}"} class="ml-2 mb-2">
                <.link patch={~p"/scape/#{@scape_id}"}>
                  <.button>
                    <p>Observe Scape <%= "\"#{@license.scape_name}\"" %></p>
                  </.button>
                </.link>
              </div>
            <% end %>
          </div>
        <% end %>
        <div class="flex flex-row items-center">
          <%= for status <- Status.to_list(@license.status) do %>
            <div class={"badge rounded border m-1 p-1 #{status}-status"}><%= status %></div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end

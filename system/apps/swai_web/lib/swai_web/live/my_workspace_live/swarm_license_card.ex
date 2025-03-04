defmodule SwaiWeb.MyWorkspaceLive.SwarmLicenseCard do
  @moduledoc """
  The SwarmLicenseCard is a live component that renders a card for a License.
  """
  use SwaiWeb, :live_component

  require Flags

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
    <div class="license-section-card">
      <div class="section-card-header">
        <.live_component
          id={"license-status-box-#{@license.license_id}"}
          module={SwaiWeb.LicenseStatusBox}
          license={@license}
          scape_id={@license.scape_id}
        />
      </div>
    </div>
    """
  end
end

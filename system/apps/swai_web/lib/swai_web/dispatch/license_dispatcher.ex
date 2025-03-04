defmodule SwaiWeb.LicenseDispatcher do
  @moduledoc false

  alias Licenses.Service, as: Licenses

  alias Schema.SwarmLicense, as: License
  alias Schema.SwarmLicense.Status, as: LicenseStatus

  alias TrainSwarmProc.CommandedApp, as: ProcApp
  alias TrainSwarmProc.PauseLicense.CmdV1, as: PauseLicense

  require Logger

  def pause_licenses(edge_id) do
    case Licenses.get_for_edge!(edge_id) do
      [] ->
        Logger.warning("detach_licenses: no licenses found to pause for edge_id: #{edge_id}")
        []

      licenses ->
        licenses
        |> Enum.each(fn %{license_id: agg_id} = license ->
          Logger.alert("Pausing License: #{inspect(license)}")

          pause_info = %License{
            license
            | license_id: agg_id,
              scape_id: nil,
              hive_id: nil,
              edge_id: nil,
              status: LicenseStatus.license_paused()
          }

          pause_license_cmd = %PauseLicense{
            agg_id: agg_id,
            version: 1,
            payload: pause_info
          }

          ProcApp.dispatch(pause_license_cmd)
        end)
    end
  end
end

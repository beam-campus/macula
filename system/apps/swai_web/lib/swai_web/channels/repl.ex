defmodule SwaiWeb.Channels.Repl do
  @moduledoc """
  This module is used to send messages to the edge clients.
  """
  alias Schema.Vector, as: Vector
  alias Edges.Service, as: Edges
  alias SwaiWeb.EdgeChannel, as: EdgeChannel
  alias Scape.Init, as: ScapeInit
  alias Schema.SwarmLicense, as: SwarmLicense
  alias Schema.SwarmLicense.Status, as: LicenseStatus
  alias Edge.Init, as: EdgeInit

  require Logger

  def try_start_scape() do
    %EdgeInit{} =
      edge_init =
      random_edge_init()

    Logger.info("Starting scape on edge: #{edge_init.id}")

    %SwarmLicense{} =
      license =
      edge_init
      |> random_license()

    Logger.info("Starting scape for license: #{license.license_id}")

    %ScapeInit{} =
      scape_init =
      license
      |> random_scape_init()

    Logger.info("Starting scape for scape: #{scape_init.id}")

    start_scape(edge_init, scape_init)
  end

  defp random_edge_init() do
    Edges.get_all()
    |> Enum.random()
  end

  defp start_scape(%EdgeInit{} = edge_init, %ScapeInit{} = scape_init) do
    Logger.info("Starting scape for edge: #{edge_init.biotope_name}")

    EdgeChannel.start_scape(edge_init, scape_init)
  end

  defp random_license(%EdgeInit{} = edge_init) do
    %SwarmLicense{
      license_id: UUID.uuid4(),
      swarm_name: "Random Swarm",
      user_id: UUID.uuid4(),
      biotope_id: edge_init.biotope_id,
      algorithm_id: "some_algorithm_id",
      algorithm_acronym: edge_init.algorithm_acronym,
      cost_in_tokens: 1000,
      status: LicenseStatus.license_paid()
    }
  end

  defp random_scape_init(%SwarmLicense{} = swarm_license) do
    %ScapeInit{
      scape_id: "scape-#{UUID.uuid4()}",
      edge_id: swarm_license.edge_id,
      scape_status: LicenseStatus.license_paid(),
      hives_cap: 100,
      particles_cap: 1000,
      biotope_id: swarm_license.biotope_id,
      biotope_name: swarm_license.biotope_name,
      image_url: "https://some_image_url",
      theme: "some_theme",
      tags: ["tag1", "tag2"],
      algorithm_id: swarm_license.algorithm_id,
      algorithm_name: swarm_license.algorithm_name,
      algorithm_acronym: swarm_license.algorithm_acronym
    }
  end
end

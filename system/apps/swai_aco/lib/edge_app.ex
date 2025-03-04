defmodule SwaiAco.EdgeApp do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc """
    Edge.Application is the main application for the Swai Edge.
  """
  use Application, otp_app: :swai_aco

  require Logger

  alias Edge.Init, as: EdgeInit
  alias Schema.AlgorithmId, as: AlgorithmId
  alias Swai.Defaults, as: Defaults

  @planet_of_ants_id "b105f59e-42ce-4e85-833e-d123e36ce943"
  @biotope_id @planet_of_ants_id

  @biotope_name "Planet of Ants"
  @algorithm_acronym "ACO"
  @algorithm_id AlgorithmId.aco_algorithm_id()

  @hives_cap Defaults.hives_cap()
  @particles_cap Defaults.particles_cap()

  def start_edge(edge_init) do
    Supervisor.start_child(
      __MODULE__,
      {Edge.System, edge_init}
    )
  end

  def handle_info({:EXIT, _pid, reason}, state) do
    Logger.error("Edge App is exiting. reason: #{inspect(reason, pretty: true)}")
    {:stop, :normal, state}
  end

  @impl Application
  def start(_type, _args) do
    %EdgeInit{} = edge_init = EdgeInit.enriched()

    edge_init =
      %EdgeInit{
        edge_init
        | biotope_id: @biotope_id,
          biotope_name: @biotope_name,
          algorithm_acronym: @algorithm_acronym,
          algorithm_id: @algorithm_id,
          hives_cap: @hives_cap,
          particles_cap: @particles_cap
      }

    IO.puts("\n\n\n
    +----------------------------------------------+
    |           MACULA EDGE RUNTIME                |
    |        Ant Colony Optimization (ACO)         |
    +----------------------------------------------+

    node:     #{edge_init.edge_id}
    biotope:  #{edge_init.biotope_name}
    key:      #{edge_init.api_key}
    country:  #{edge_init.country}
    city:     #{edge_init.city}
    capacity: #{edge_init.scapes_cap}


    \n\n\n")

    Process.sleep(2_000)

    children = [
      {Swai.Registry, name: EdgeRegistry},
      {Phoenix.PubSub, name: :edge_pubsub},
      {Edge.Client, edge_init}
    ]

    case Supervisor.start_link(
           children,
           name: __MODULE__,
           strategy: :one_for_one
         ) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start Edge.Application: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @impl Application
  def stop(scape_init) do
    Edge.System.terminate(:normal, scape_init)
    Supervisor.stop(__MODULE__)
  end

  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start, []}
    }
  end
end

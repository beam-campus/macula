defmodule Swai.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications

  @moduledoc """
  The main application module for Swai.
  """

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster, query: Application.get_env(:swai, :dns_cluster_query) || :ignore},
      {Swai.Registry, name: Swai.Registry},
      {Phoenix.PubSub, name: Swai.PubSub},
      {Finch, name: Swai.Finch},
      {Swai.Repo, name: Swai.Repo},
      {Swai.CachesSystem, name: Web.CachesSystem}
    ]

    Supervisor.start_link(
      children, 
      strategy: :one_for_one, 
      name: Swai.Supervisor)
  end
end

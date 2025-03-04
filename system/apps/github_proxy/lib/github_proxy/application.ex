defmodule GithubProxy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application, otp_app: :github_proxy

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: GithubProxy.Worker.start_link(arg)
      # {GithubProxy.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GithubProxy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

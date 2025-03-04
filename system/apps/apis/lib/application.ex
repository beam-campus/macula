defmodule Apis.Application do
  use Application, otp_app: :apis
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications

  @moduledoc """
  The main application module for Swai.
  """
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Apis.Countries, [true]}
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: Apis.Supervisor
    )
  end
end

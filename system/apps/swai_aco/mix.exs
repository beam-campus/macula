defmodule Aco.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :swai_aco,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :apis, :runtime_tools],
      mod: {SwaiAco.EdgeApp, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:slipstream, "~> 1.1.0"},
      {:axon, ">= 0.5.0"},
      # {:ex_webrtc, "~> 0.6.3", override: true},
      # {:ex_sctp, "~> 0.1.1", override: true},
      {:swai_core, in_umbrella: true},
      {:apis, in_umbrella: true}
    ]
  end
end

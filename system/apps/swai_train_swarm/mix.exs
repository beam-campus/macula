defmodule TrainSwarm.MixProject do
  use Mix.Project

  def project do
    [
      app: :swai_train_swarm,
      version: "0.1.0",
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
      extra_applications: [:logger, :swai],
      mod: {Swai.TrainSwarm.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.11.2"},
      {:elixir_uuid, "~> 1.2", override: true},
      {:commanded, "~> 1.4"},
      {:commanded_extreme_adapter, "~> 1.1"},
      {:swai, in_umbrella: true}
    ]
  end
end

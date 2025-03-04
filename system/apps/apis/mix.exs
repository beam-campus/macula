defmodule Apis.MixProject do
  use Mix.Project

  def project do
    [
      app: :apis,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # ExDoc
      name: "APIs Library",
      source_url: "https://github.com/beam-campus/swai/system/apps/apis",
      homepage_url: "https://DisComCo.pl",
      docs: [
        main: "APIs Library",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Apis.Application, []},
      extra_applications: [:logger, :eex]
    ]
  end

  # Specifies which paths to compile per environment.
  # defp elixirc_paths(:test), do: ["lib", "test/support"]
  # defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 1.2.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34.0", only: [:dev], runtime: false},
      {:dialyze, "~> 0.2.0", only: [:dev]},
      {:dialyxir, "~> 1.4.3", only: [:dev], runtime: false},
      {:elixir_uuid, "~> 1.2"},
      {:jason, "~> 1.4.1"},
      {:req, "~> 0.5"},
      {:typed_struct, "~> 0.3.0"},
      {:hackney, "~> 1.20.1"},
      {:mnemonic_slugs, "~> 0.0.3"},
      {:cachex, "~> 3.6.0"}
    ]
  end
end

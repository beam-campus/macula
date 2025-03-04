defmodule SwaiWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :swai_web,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SwaiWeb.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :observer,
        :os_mon,
        :swai_train_swarm
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.12"},
      {:phoenix_ecto, "~> 4.5.1"},
      {:ecto_sql, "~> 3.11.1"},
      # {:postgrex, ">= 0.17.5"},
      {:floki, ">= 0.36.1"},
      {:phoenix_html, "~> 4.1.1"},
      {:phoenix_live_reload, "~> 1.5.3", only: :dev},
      {:phoenix_live_view, "~> 0.20.14"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8.1"},
      {:tailwind, "~> 0.2.2"},
      {:telemetry_metrics, "~> 1.0.0"},
      {:telemetry_poller, "~> 1.1.0"},
      {:gettext, "~> 0.24.0"},
      {:plug_cowboy, "~> 2.7.1"},
      {:contex, "~> 0.5.0"},
      {:jason, "~> 1.4.1"},
      {:bandit, "~> 1.4.2"},
      {
        :heroicons,
        github: "tailwindlabs/heroicons",
        tag: "v2.1.3",
        sparse: "optimized",
        app: false,
        compile: false,
        depth: 1
      },
      {:httpoison, "~> 1.8"},
      {:tesla, "~> 1.4"},
      {:cors_plug, "~> 3.0"},
      {:heroicons_liveview, "~> 0.5.0"},
      {:hpax, "~> 0.1.1", override: true},
      # {:ex_webrtc, "~> 0.5.0"},
      # {:ex_sctp, "~> 0.1.0"},
      {:apis, in_umbrella: true},
      {:swai_core, in_umbrella: true},
      {:swai, in_umbrella: true},
      {:swai_train_swarm, in_umbrella: true}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": [
        "tailwind.install --if-missing",
        "esbuild.install --if-missing"
      ],
      "assets.build": [
        "tailwind swai_web",
        "esbuild swai_web"
      ],
      "assets.deploy": [
        "tailwind swai_web --minify",
        "esbuild swai_web --minify",
        "phx.digest"
      ]
    ]
  end
end

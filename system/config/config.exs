# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :elixir_rakv,
  data_dir: "/volume/swai/data",
  wal_data_dir: "/volume/swai/wal_data"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :initial_call, :mfa]

config :swai_aco,
  scape_id: "5693504a-89d6-4af3-bb70-2c2914913dc9"

config :swai_train_swarm, TrainSwarmProc.CommandedApp, log_level: :info

config :swai_train_swarm, TrainSwarmProc.CommandedApp,
  snapshotting: %{
    TrainSwarmProc.Aggregate => [
      snapshot_every: 10_000,
      snapshot_version: 1
    ]
  }

config :swai_train_swarm, TrainSwarmProc.CommandedApp,
  event_store: [
    log_level: :info,
    adapter: Commanded.EventStore.Adapters.Extreme,
    serializer: Commanded.Serialization.JsonSerializer,
    stream_prefix: "train_swarm",
    extreme: [
      log_level: :info,
      db_type: :node,
      host: "localhost",
      port: 1113,
      username: "admin",
      password: "changeit",
      reconnect_delay: 2_000,
      max_attempts: :infinity
    ]
  ],
  pubsub: :local,
  registry: :local

config :github_proxy,
  github_token: System.get_env("GITHUB_PAT_SWARM_WARS_SCAPE")

config :swai_edge, Macula.SignalClient,
  rings_url: "http://localhost:4000/api/rings"

config :swai_edge, Macula.Ringcaster,
  uri: "ws://localhost:4000/ring_socket/websocket",
  reconnect_after_msec: [
    202 * :rand.uniform(11),
    505 * :rand.uniform(12),
    1_010 * :rand.uniform(13),
    2_020 * :rand.uniform(14)
    # 6_060 * :rand.uniform(15),
    # 10_101 * :rand.uniform(16),
    # 20_202 * :rand.uniform(17),
    # 30_303 * :rand.uniform(18),
    # 60_606 * :rand.uniform(19),
  ],
  rejoin_after_msec: [
    202 * :rand.uniform(11),
    505 * :rand.uniform(12),
    1_010 * :rand.uniform(13),
    2_020 * :rand.uniform(14)
    # 6_060 * :rand.uniform(15),
    # 10_101 * :rand.uniform(16),
    # 20_202 * :rand.uniform(17),
    # 30_303 * :rand.uniform(18),
    # 60_606 * :rand.uniform(19),
  ]


config :swai_edge, Edge.Client,
  uri: "ws://localhost:4000/edge_socket/websocket",
  reconnect_after_msec: [
    202 * :rand.uniform(11),
    505 * :rand.uniform(12),
    1_010 * :rand.uniform(13),
    2_020 * :rand.uniform(14)
    # 6_060 * :rand.uniform(15),
    # 10_101 * :rand.uniform(16),
    # 20_202 * :rand.uniform(17),
    # 30_303 * :rand.uniform(18),
    # 60_606 * :rand.uniform(19),
  ],
  rejoin_after_msec: [
    202 * :rand.uniform(11),
    505 * :rand.uniform(12),
    1_010 * :rand.uniform(13),
    2_020 * :rand.uniform(14)
    # 6_060 * :rand.uniform(15),
    # 10_101 * :rand.uniform(16),
    # 20_202 * :rand.uniform(17),
    # 30_303 * :rand.uniform(18),
    # 60_606 * :rand.uniform(19),
  ]

# Configure Mix tasks and generators
config :swai,
  ecto_repos: [Swai.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :swai, Swai.Mailer, adapter: Swoosh.Adapters.Local

config :swai_web,
  ecto_repos: [Swai.Repo],
  generators: [
    context_app: :swai,
    migration: true,
    binary_id: true,
    timestamp_type: :utc_datetime_usec,
    # UUID.nil()
    sample_binary_id: "00000000-0000-0000-0000-000000000000"
  ]

# configure RemoteImageController
config :swai_web, SwaiWeb.RemoteImageController, base_url: "https://localhost:4000"

# Configures the endpoint
config :swai_web, SwaiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  server: true,
  render_errors: [
    formats: [html: SwaiWeb.ErrorHTML, json: SwaiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Swai.PubSub,
  live_view: [signing_salt: "KEqR3A8v"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  swai_web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/* --external:/data/*),
    cd: Path.expand("../apps/swai_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  swai_web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/swai_web/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time[$level] $metadata: $message\n",
  metadata: [:request_id, :initial_call, :mfa]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

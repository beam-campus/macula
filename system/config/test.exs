import Config


# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

# Only in tests, remove the complexity from the password hashing algorithm
config :argon2_elixir, t_cost: 1, m_cost: 8

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
# Configure your database
config :swai, Swai.Repo,
  username: "swai_dev",
  password: "swai_dev",
  hostname: "localhost",
  database: "swai_test",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  log: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :swai_web, SwaiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "JTn0x9o92aIfICOL2mHTIq+fX5rhnyPZZHZgJ+DxIBiQA2nwKlS05LFPxddqFulL",
  server: false

# Print only warnings and errors during test
config :logger, :console,
  level: :debug,
  format: "$time[$level]\e[33;44m$metadata\e[0m>> $message\n",
  metadata: [:request_id, :initial_call, :mfa]

# In test we don't send emails.
config :swai, Swai.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

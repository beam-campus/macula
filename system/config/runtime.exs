import Config

# if System.get_env("PHX_SERVER") do
#   config :swai_web, SwaiWeb.Endpoint, server: true
# end

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do
  database_url =
    System.get_env("SWAI_DB_URL") ||
      raise """
      environment variable SWAI_DB_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :swai, Swai.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  ### MAYBE SQLite #################################################
  # database_path =
  #   System.get_env("SWAI_DB_PATH") ||
  #     raise """
  #     environment variable DATABASE_PATH is missing.
  #     For example: /etc/test_auth/test_auth.db
  #     """
  # config :swai, Swai.Repo,
  #   database: database_path,
  #   pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5")
  ##################################################################

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SWAI_SECRET_KEY_BASE") ||
      raise """
      environment variable SWAI_SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :swai_web, SwaiWeb.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    server: true,
    secret_key_base: secret_key_base

    # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :swai_web, SwaiWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## SSL Support
  #
  # To get SSL working, you will need to add the `https` key
  # to your endpoint configuration:
  #
  #     config :swai_web, SwaiWeb.Endpoint,
  #       https: [
  #         ...,
  #         port: 443,
  #         cipher_suite: :strong,
  #         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
  #         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
  #       ]
  #
  # The `cipher_suite` is set to `:strong` to support only the
  # latest and more secure SSL ciphers. This means old browsers
  # and clients may not be supported. You can set it to
  # `:compatible` for wider support.
  #
  # `:keyfile` and `:certfile` expect an absolute path to the key
  # and cert in disk or a relative path inside priv, for example
  # "priv/ssl/server.key". For all supported SSL configuration
  # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
  #
  # We also recommend setting `force_ssl` in your config/prod.exs,
  # ensuring no data is ever sent via http, always redirecting to https:
  #
  #     config :swai_web, SwaiWeb.Endpoint,
  #       force_ssl: [hsts: true]
  #
  # Check `Plug.SSL` for all available options in `force_ssl`.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  config :swai, Swai.Mailer,
    adapter: Swoosh.Adapters.Mailgun,
    api_key: System.get_env("SWAI_MAILGUN_API_KEY"),
    domain: System.get_env("SWAI_MAILGUN_DOMAIN"),
    base_url: System.get_env("SWAI_MAILGUN_BASE_URL")

  # config :swai, Swai.Mailer,
  #   adapter: Swoosh.Adapters.SMTP,
  #   relay: System.get_env("SWAI_SMTP_RELAY"),
  #   username: System.get_env("SWAI_SMTP_USERNAME"),
  #   password: System.get_env("SWAI_SMTP_PASSWORD"),
  #   port: String.to_integer(System.get_env("SWAI_SMTP_PORT") || "587"),
  #   tls: :always,
  #   auth: :always,
  #   ssl: true,
  #   # dkim: [
  #   #   d: System.get_env("SWAI_SMTP_DKIM_DOMAIN"),
  #   #   s: System.get_env("SWAI_SMTP_DKIM_SELECTOR"),
  #   #   private_key: System.get_env("SWAI_SMTP_DKIM_PRIVATE_KEY")
  #   # ],
  #   retries: 3,
  #   no_mx_lookups: false

  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.

  config :swai, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")
end

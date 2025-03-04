defmodule SwaiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :swai_web

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_swai_web_key",
    signing_salt: "KJshPqW2",
    same_site: "Lax"
  ]

  socket("/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]
  )

  socket("/edge_socket", SwaiWeb.EdgeSocket,
    websocket: true,
    longpoll: false
  )

  socket("/ring", SwaiWeb.RingSocket,
    websocket: true,
    longpoll: false
  )

  plug(CORSPlug, origin: "*")
  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: :swai_web,
    gzip: false,
    only: SwaiWeb.static_paths()
  )

  # PrimerLive resources
  # plug(Plug.Static,
  #   at: "/primer_live",
  #   from: {:primer_live, "priv/static"}
  # )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
    plug(Phoenix.Ecto.CheckRepoStatus, otp_app: :swai_web)
  end

  plug(Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"
  )

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Plug.Session, @session_options)

  plug(SwaiWeb.Router)
end

defmodule SwaiWeb.Router do
  use SwaiWeb, :router

  import SwaiWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {SwaiWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(CORSPlug)
    plug(:accepts, ["json"])
  end

  scope "/", SwaiWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
  end


  pipeline :auth do
    plug :admin_auth
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:swai_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: SwaiWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  scope "/api", SwaiWeb do
    pipe_through(:api)

    get("/identicon/:input", IdenticonController, :show)
    get("/biotope_images/:id/image_url", RemoteImageController, :image_url)
    post("/rings", RingsController, :register_offer)
    get("/rings/:scape_id", RingsController, :get_ring_offer)
    # get "/countries", CountriesController, :index
  end

  scope "/", SwaiWeb do
    pipe_through([:browser])

    live_session :edges_info,
      on_mount: [
        {SwaiWeb.EdgesInfo, :mount_edges_count},
        {SwaiWeb.UserAuth, :mount_current_user}
      ] do
      live("/scapes", ScapesLive.Index, :index)
      live("/macula", EdgesLive.Index, :index)
      live("/hives", EdgesLive.Index, :index)
      live("/marketplace", MarketplaceLive.Index, :index)
      live("/terms_of_service", TermsOfServiceLive.Index, :show)
      live("/privacy_policy", PrivacyPolicyLive.Index, :show)
      live("/about", OurMissionLive.Index, :show)
      live("/mission", OurMissionLive.Index, :show)
    end
  end

  ## Authentication routes

  scope "/", SwaiWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [
        {SwaiWeb.UserAuth, :redirect_if_user_is_authenticated},
        {SwaiWeb.EdgesInfo, :mount_edges_count}
      ] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", SwaiWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [
        {SwaiWeb.UserAuth, :ensure_authenticated},
        {SwaiWeb.EdgesInfo, :mount_edges_count}
      ] do
      live("/users/settings", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)
      live("/my_workspace", MyWorkspaceLive.Index, :index)
      live("/train_swarm/:biotope_id", InitializeSwarmLive.Index, :index)
      live("/marketplace/start-swarm/:biotope_id", MarketplaceLive.Index, :start_swarm)
      live("/swarm_licenses", SwarmLicenseLive.Index, :index)
      live("/scape/:scape_id", ScapeViewLive.Index, :view)
    end
  end

  scope "/", SwaiWeb do
    pipe_through([:browser])
    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [
        {SwaiWeb.UserAuth, :mount_current_user},
        {SwaiWeb.EdgesInfo, :mount_edges_count}
      ] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end

  defp admin_auth(conn, _opts) do
    username = Application.fetch_env!(:broadcaster, :admin_username)
    password = Application.fetch_env!(:broadcaster, :admin_password)
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end

end

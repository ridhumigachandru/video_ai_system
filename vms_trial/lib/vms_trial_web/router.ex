defmodule VmsTrialWeb.Router do
  use VmsTrialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VmsTrialWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VmsTrialWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/annotated_video", VideoStreamController, :stream
    live "/video_jobs", VideoJobLive.Index, :index
    live "/video_jobs/new", VideoJobLive.Form, :new
    live "/video_jobs/:id", VideoJobLive.Show, :show
    live "/video_jobs/:id/edit", VideoJobLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", VmsTrialWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:vms_trial, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VmsTrialWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

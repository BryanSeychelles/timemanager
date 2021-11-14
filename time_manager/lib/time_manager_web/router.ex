defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  alias TimeManagerWeb.Guardian

  pipeline :api do
    plug :accepts, ["json"]
    plug(CORSPlug, origin: ["*"])
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/", TimeManagerWeb do
    pipe_through :api

    get "/index", PageController, :index
  end

  scope "/api", TimeManagerWeb do
    pipe_through [:api, :jwt_authenticated]

    scope "/users" do
      get "/", UserController, :show
      get "/all", UserController, :index
      get "/:userID", UserController, :show
      put "/:userID", UserController, :update
      put "/:userID/promote", UserController, :promote
      delete "/:userID", UserController, :delete
      options "/", UserController, :options
      options "/:userID", UserController, :options
      options "/:userID/promote", UserController, :options
    end
  end

  # Other scopes may use custom stacks.
  scope "/api", TimeManagerWeb do
    pipe_through :api

    scope "/users" do
      post "/", UserController, :create
      post "/sign_in", UserController, :sign_in
      options "/sign_in", UserController, :options
    end

    scope "/workingtimes" do
      get "/:user_id", WorkingtimeController, :show
      get "/:user_id/:id", WorkingtimeController, :show
      post "/:user_id", WorkingtimeController, :create
      put "/:id", WorkingtimeController, :update
      delete "/:id", WorkingtimeController, :delete
      options "/", WorkingtimeController, :options
      options "/:user_id", WorkingtimeController, :options
      options "/:user_id/:id", WorkingtimeController, :options
      options "/:id", WorkingtimeController, :options
    end

    scope "/clocks" do
      get "/:user_id", ClockController, :show
      post "/:user_id", ClockController, :create
      put "/:user_id", ClockController, :update
      options "/:user_id", ClockController, :options
    end

    scope "/teams" do
      get "/all", TeamController, :index
      get "/:user_id", TeamController, :show
      get "/:id/users", UserController, :show_users_of_team
      post "/", TeamController, :create
      put "/:user_id", TeamController, :update
      delete "/:user_id", TeamController, :delete
      options "/", TeamController, :options
      options "/:user_id", TeamController, :options
    end
  end



  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :api
      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :api

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

defmodule FireweedWeb.Router do
  @root [id: "root", container: {:div, [{"data-root", ""}]}]

  use FireweedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FireweedWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug FireweedWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug :logged_in_user
  end

  scope "/", FireweedWeb do
    pipe_through :browser

    live "/", PageLive, :index, @root

    live "/signup", UsersLive.SignUp, :signup, @root

    get("/signin", SessionController, :login)
    post("/signin", SessionController, :signin)

    get("/login/:token/email/:email", SessionController, :create_from_token)
    get("/logout", SessionController, :delete)

    get("/forgot", SessionController, :forgot)
    post("/forgot", SessionController, :reset_pass)

    # resources(
    #   "/sessions",
    #   SessionController,
    #   only: [:new, :create, :delete],
    #   singleton: true
    # )
  end


  scope "/", FireweedWeb do
    pipe_through [:browser, :protected]

    live "/nutrition/", NutritionLive.Index, :index, @root
    live "/nutrition/:food_id", NutritionLive.Index, :show, @root

    live "/heartrate/", HeartRateLive.Index, :index, @root

    live "/map/", MapLive.Index, :index, @root

    live "/users", UsersLive.Index, :index, @root
    live "/users/:id", UsersLive.Index, :show, @root
    live "/users/:id/edit", UsersLive.Index, :edit, @root
  end

  # Other scopes may use custom stacks.
  # scope "/api", FireweedWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FireweedWeb.Telemetry
    end
  end
end

defmodule BookclubWeb.Router do
  use BookclubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug BookclubWeb.Plugs.Context
  end

  scope "/", BookclubWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/logout", LoginController, :delete
    delete "/logout", LoginController, :delete
    get "/login", LoginController, :login
    post "/login", LoginController, :create
    get "/dashboard",  UserController, :dashboard

    get "/users/new", UserController, :new
    get "/users", UserController, :index
    get "/users/:id/edit", UserController, :edit
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    patch "/users/:id", UserController, :update
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    forward("/graphql", Absinthe.Plug, schema: BookclubWeb.Schema)

    if Mix.env() == :dev do
      forward("/graphiql", Absinthe.Plug.GraphiQL, schema: BookclubWeb.Schema)
    end
  end

end

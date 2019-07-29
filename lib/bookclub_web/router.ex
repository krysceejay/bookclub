defmodule BookclubWeb.Router do
  use BookclubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BookclubWeb.Plugs.AuthUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug BookclubWeb.Plugs.Context
  end

  scope "/", BookclubWeb do
    pipe_through :browser

    get "/", LoginController, :login
    get "/logout", LoginController, :delete
    delete "/logout", LoginController, :delete
    get "/login", LoginController, :login
    post "/login", LoginController, :create
    get "/dashboard",  AdminController, :dashboard
    get "/users",  AdminController, :users
    get "/user/:id",  AdminController, :user
    get "/books",  AdminController, :books
    get "/book/:id",  AdminController, :book


  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
    schema: BookclubWeb.Schema

    if Mix.env == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BookclubWeb.Schema
    end
  end

end

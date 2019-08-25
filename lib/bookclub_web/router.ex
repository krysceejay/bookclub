defmodule BookclubWeb.Router do
  use BookclubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BookclubWeb.Plugs.AuthUser
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug BookclubWeb.Plugs.Context
  end

  pipeline :admin_dashboard do
    plug :put_layout, {BookclubWeb.LayoutView, :admin}
  end

  pipeline :chat_layout do
    plug :put_layout, {BookclubWeb.LayoutView, :chat}
  end

  scope "/bkadmin", BookclubWeb do
    pipe_through [:browser, :admin_dashboard]

    get "/",  AdminController, :dashboard
    get "/users",  AdminController, :users
    get "/user/:id",  AdminController, :user
    get "/books",  AdminController, :books
    get "/book/:id",  AdminController, :book

  end

  scope "/chat", BookclubWeb do
    pipe_through [:browser, :chat_layout]

    get "/:slug",  ChatController, :index

  end

  scope "/", BookclubWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/books", HomeController, :books
    get "/book/:slug",  HomeController, :book

    get "/logout", AuthController, :delete
    delete "/logout", AuthController, :delete
    get "/login", AuthController, :loginform
    post "/login", AuthController, :login
    get "/register", AuthController, :registerform
    post "/register", AuthController, :register

    get "/dashboard", UserController, :index
    get "/dashboard/addbook", UserController, :addbook
    post "/dashboard/createbook", UserController, :createbook
    get "/dashboard/editbook/:id", UserController, :editbook
    put "/dashboard/updatebook/:id", UserController, :updatebook

  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
    schema: BookclubWeb.Schema

    if Mix.env == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BookclubWeb.Schema,
      socket: BookclubWeb.UserSocket,
      interface: :advanced

    end
  end

end

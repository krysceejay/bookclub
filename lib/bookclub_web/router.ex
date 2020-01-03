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

  pipeline :user_dashboard do
    plug :put_layout, {BookclubWeb.LayoutView, :user}
  end

  pipeline :chat_layout do
    plug :put_layout, {BookclubWeb.LayoutView, :chat}
  end

  scope "/bkadmin", BookclubWeb do
    pipe_through [:browser, :admin_dashboard]

    get "/", AdminController, :dashboard
    get "/users", AdminController, :users
    get "/user/:id", AdminController, :user
    get "/books", AdminController, :books
    get "/book/:id", AdminController, :book
  end

  scope "/dashboard", BookclubWeb do
    pipe_through [:browser, :user_dashboard]

    get "/", UserController, :index
    get "/managebooks", UserController, :managebooks
    get "/addbook", UserController, :addbook
    post "/createbook", UserController, :createbook
    get "/editbook/:slug", UserController, :editbook
    put "/updatebook/:slug", UserController, :updatebook
    get "/book-readers/:slug", UserController, :bookreaders
    get "/join-readers/:slug", UserController, :joinreaders
    get "/profile/:name", UserController, :profile
    get "/editprofile", UserController, :editprofile
    put "/updateprofile", UserController, :updateprofile
    get "/joinedlist", UserController, :joinedlist
    get "/undojoin/:slug", UserController, :undojoin
    get "/reader-status/:name", UserController, :readerstatus


  end

  scope "/chat", BookclubWeb do
    pipe_through [:browser, :chat_layout]

    get "/:slug", ChatController, :index
  end

  scope "/", BookclubWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/books", HomeController, :books
    get "/book/:slug", HomeController, :book
    get "/genre/:slug", HomeController, :genre
    get "/searchbooks", HomeController, :searchbooks
    get "/contact", HomeController, :contact
    post "/rate-book", HomeController, :createrating
    get "/reviews/:slug", HomeController, :reviews

    get "/not-found", HomeController, :notfound

    get "/logout", AuthController, :delete
    delete "/logout", AuthController, :delete
    get "/login", AuthController, :loginform
    post "/login", AuthController, :login
    get "/register", AuthController, :registerform
    post "/register", AuthController, :register
  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: BookclubWeb.Schema

    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: BookclubWeb.Schema,
        socket: BookclubWeb.UserSocket,
        interface: :advanced
    end
  end
end

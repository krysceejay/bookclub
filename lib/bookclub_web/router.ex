defmodule BookclubWeb.Router do
  use BookclubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BookclubWeb.Plugs.AuthUser
  end

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
    plug BookclubWeb.Plugs.Context
  end

  pipeline :upload do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
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

  pipeline :nolayout_layout do
    plug :put_layout, {BookclubWeb.LayoutView, :nolayout}
  end

  scope "/upload", BookclubWeb do
    pipe_through :upload

    post "/:path", UploadController, :uploadFile
    post "/delete/:path", UploadController, :deleteFile
  end

  scope "/bkadmin", BookclubWeb do
    pipe_through [:browser, :admin_dashboard]

    get "/", AdminController, :dashboard
    get "/users", AdminController, :users
    get "/user/:id", AdminController, :user
    get "/books", AdminController, :books
    get "/book/:id", AdminController, :book
    get "/genres", AdminController, :genres
    get "/addgenre", AdminController, :addgenre
    post "/creategenre", AdminController, :creategenre
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

    get "/book-topic/:slug", UserController, :booktopic
    get "/addtopic/:slug", UserController, :addtopic
    post "/createtopic/:slug", UserController, :createtopic
    get "/edittopic/:slug", UserController, :edittopic
    put "/updatetopic/:slug", UserController, :updatetopic

    get "/shelf/read/:slug", UserController, :readbook


  end

  scope "/chat", BookclubWeb do
    pipe_through [:browser, :chat_layout]

    get "/:slug", ChatController, :index

  end

  scope "/confirm", BookclubWeb do
    pipe_through [:browser, :nolayout_layout]

    get "/email/:slug", AuthController, :confirmemail
    get "/reset/:slug", AuthController, :resetpassemail
    get "/welcome", AuthController, :welcome
  end

  scope "/", BookclubWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/shelf", HomeController, :books
    get "/shelf/:slug", HomeController, :book
    get "/genre/:slug", HomeController, :genre
    get "/searchbooks", HomeController, :searchbooks
    get "/contact", HomeController, :contact
    post "/rate-book", HomeController, :createrating
    get "/ratings/:slug", HomeController, :ratings

    get "/logout", AuthController, :delete
    delete "/logout", AuthController, :delete
    get "/login", AuthController, :loginform
    post "/login", AuthController, :login
    get "/register", AuthController, :registerform
    post "/register", AuthController, :register
    get "/reset-password", AuthController, :resetform
    post "/reset", AuthController, :reset

    get "/email-verify/:token", AuthController, :verifytoken
    get "/reset-password/:token", AuthController, :resetpasswordform
    put "/reset-password/:slug", AuthController, :resetpass
    post "/reset-password/:slug", AuthController, :resetpass

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

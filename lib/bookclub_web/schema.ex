defmodule BookclubWeb.Schema do
  use Absinthe.Schema

  alias BookclubWeb.Schema.Types
  alias BookclubWeb.Resolvers
  alias BookclubWeb.Schema.Middleware
  alias Bookclub.{Accounts, Content}

  #import Types
  import_types Types
  import_types Absinthe.Plug.Types

  def context(ctx) do
  loader =
    Dataloader.new
    |> Dataloader.add_source(Accounts, Accounts.data())
    |> Dataloader.add_source(Content, Content.data())

  Map.put(ctx, :loader, loader)
  end

def plugins do
  [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
end

  query do

    @desc "Get all users"
    field :users, list_of(:user_type) do
      #Resolver
      middleware Middleware.Authorize, 2
      resolve &Resolvers.UserResolver.users/3
    end

    @desc "Get single user"
    field :user, :user_type do
      #middleware Middleware.Authorize, :any
      arg :id, non_null(:id)
      resolve &Resolvers.UserResolver.user/3
    end

    @desc "Get all roles"
    field :roles, list_of(:role_type) do
      middleware Middleware.Authorize, 2
      resolve &Resolvers.RoleResolver.roles/3
    end

    @desc "Get all books"
    field :allbooks, list_of(:book_type) do
      resolve &Resolvers.BookResolver.all_books/3
    end

  end

  mutation do
    @desc "Register user"
    field :register_user, type: :user_payload do
      arg :input, non_null(:user_input_type)
      resolve &Resolvers.UserResolver.create/2
    end

    @desc "Login a user and return JWT token"
    field :login_user, type: :session_type do
      arg :input, non_null(:session_input_type)
      resolve &Resolvers.SessionResolver.login_user/3
    end

    @desc "Create role"
    field :create_role, type: :role_type do
      arg :input, non_null(:role_input_type)
      resolve &Resolvers.RoleResolver.create_role/3
    end

    @desc "Create book"
    field :create_book, :book_type do
      arg :input, non_null(:book_input_type)
      resolve &Resolvers.BookResolver.create_book/3
    end

    @desc "Upload file"
    field :upload_file, :string do
      arg :file_data, non_null(:upload)

      resolve fn args, _ ->
        args.file_data # this is a `%Plug.Upload{}` struct.

        {:ok, "success"}
      end
    end


  end

  subscription do
    @desc "Comment subscription"
    field :new_book, :book_type do
      config fn _args, _info ->
        {:ok, topic: "*"}
      end

    end
  end

end

defmodule BookclubWeb.Schema do
  use Absinthe.Schema

  alias BookclubWeb.Schema.Types
  alias BookclubWeb.Resolvers
  alias BookclubWeb.Schema.Middleware
  alias Bookclub.Accounts

  #import Types
  import_types Types

  def context(ctx) do
  loader =
    Dataloader.new
    |> Dataloader.add_source(Accounts, Accounts.data())

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

    @desc "Get all roles"
    field :roles, list_of(:role_type) do
      #Resolver
      #middleware Middleware.Authorize, :any
      resolve &Resolvers.RoleResolver.roles/3
    end

  end

  mutation do
    @desc "Register user"
    field :register_user, type: :user_type do
      arg :input, non_null(:user_input_type)
      resolve &Resolvers.UserResolver.register_user/3
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


  end

  # subscription do
  #
  # end

end

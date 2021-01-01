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

    @desc "Get all clubs"
    field :allclubs, list_of(:club_type) do
      resolve &Resolvers.ClubResolver.all_clubs/3
    end

    @desc "Get club"
    field :club, :club_type do
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.single_club/3
    end

    @desc "Get club polls"
    field :clubpolls, list_of(:poll_type) do
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.all_club_polls/3
    end

    @desc "Get club lists"
    field :clublists, list_of(:list_type) do
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.all_club_lists/3
    end

    @desc "Get poll votes"
    field :get_poll_votes, list_of(:collect_poll_type) do
      arg :poll_id, non_null(:id)
      resolve &Resolvers.ClubResolver.get_poll_votes/3
    end

    @desc "Get club members"
    field :get_club_members, list_of(:member_type) do
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.get_club_members/3
    end

    @desc "Get fav by user and club"
    field :get_fav_by_user_and_club, :favorite_type do
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.get_fav_by_user_and_club/3
    end

    @desc "Get club ratings"
    field :get_club_ratings, list_of(:rate_type) do
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.get_club_ratings/3
    end

    @desc "Check If User Rated"
    field :check_if_user_rated, :boolean do
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.check_if_user_rated/3
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

    @desc "Create club"
    field :create_club, :club_payload do
      middleware Middleware.Authorize, :any
      arg :input, non_null(:club_input_type)
      resolve &Resolvers.ClubResolver.create_club/3
    end

    @desc "Create member"
    field :create_member, :member_payload do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      arg :input, non_null(:member_input_type)
      resolve &Resolvers.ClubResolver.create_member/3
    end

    @desc "Add Rating"
    field :create_rate, :rate_payload do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      arg :input, non_null(:rate_input_type)
      resolve &Resolvers.ClubResolver.create_rate/3
    end

    @desc "Update Rating"
    field :update_rate, :rate_payload do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      arg :input, non_null(:rate_input_type)
      resolve &Resolvers.ClubResolver.update_rate/3
    end

    @desc "Create Poll"
    field :create_poll, :poll_payload do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      arg :input, non_null(:poll_input_type)
      resolve &Resolvers.ClubResolver.create_poll/3
    end

    @desc "Update Poll"
    field :update_poll, :poll_payload do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      arg :poll_id, non_null(:id)
      arg :input, non_null(:poll_input_type)
      resolve &Resolvers.ClubResolver.update_poll/3
    end

    @desc "Remove Poll"
    field :remove_poll, :poll_type do
      middleware Middleware.Authorize, :any
      arg :poll_id, non_null(:id)
      resolve &Resolvers.ClubResolver.delete_poll/3
    end

    @desc "Create List"
    field :create_list, :list_payload do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      arg :input, non_null(:list_input_type)
      resolve &Resolvers.ClubResolver.create_list/3
    end

    @desc "Set Poll Status"
    field :set_poll_status, :poll_type do
      middleware Middleware.Authorize, :any
      arg :poll_id, non_null(:id)
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.setPollStatus/3
    end

    @desc "Set Book Status"
    field :set_book_status, :list_type do
      middleware Middleware.Authorize, :any
      arg :list_id, non_null(:id)
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.setBookStatus/3
    end

    @desc "Vote Poll"
    field :vote_poll, :collect_poll_type do
      middleware Middleware.Authorize, :any
      arg :poll_id, non_null(:id)
      arg :input, non_null(:collect_poll_input_type)
      resolve &Resolvers.ClubResolver.vote_poll/3
    end

    @desc "Remove Vote"
    field :remove_vote, :collect_poll_type do
      middleware Middleware.Authorize, :any
      arg :vote_id, non_null(:id)
      resolve &Resolvers.ClubResolver.removeVote/3
    end

    @desc "Update Club Public"
    field :club_public, :club_type do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.setClubPublic/3
    end

    @desc "Update Club Publish"
    field :club_publish, :club_type do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.setClubPublish/3
    end

    @desc "Report Club"
    field :report_club, :report_payload do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      arg :input, non_null(:report_input_type)
      resolve &Resolvers.ClubResolver.create_report/3
    end

    @desc "Favorite Club"
    field :fav_club, :favorite_type do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.add_favorite/3
    end

    @desc "Unfavorite Club"
    field :unfav_club, :favorite_type do
      middleware Middleware.Authorize, :any
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.remove_favorite/3
    end

    @desc "Set Member Status"
    field :set_member_status, :member_type do
      middleware Middleware.Authorize, :any
      arg :user_id, non_null(:id)
      arg :club_id, non_null(:id)
      resolve &Resolvers.ClubResolver.setMemberStatus/3
    end

    @desc "Remove Member"
    field :remove_member, :member_type do
      middleware Middleware.Authorize, :any
      arg :member_id, non_null(:id)
      resolve &Resolvers.ClubResolver.removeMember/3
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

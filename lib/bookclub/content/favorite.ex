defmodule Bookclub.Content.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorites" do
    belongs_to :user, Bookclub.Accounts.User
    belongs_to :club, Bookclub.Content.Club

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:user_id, :club_id])
    |> validate_required([:user_id, :club_id])
  end
end

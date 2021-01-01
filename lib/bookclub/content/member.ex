defmodule Bookclub.Content.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    field :status, :boolean, default: true

    belongs_to :user, Bookclub.Accounts.User
    belongs_to :club, Bookclub.Content.Club

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:user_id, :club_id, :status])
    |> validate_required([:user_id, :club_id])
  end

  def set_status(member, attrs) do
    member
    |> cast(attrs, [:status])
  end

end

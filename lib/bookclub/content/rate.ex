defmodule Bookclub.Content.Rate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rates" do
    field :rating, :integer
    field :comment, :string
    belongs_to :user, Bookclub.Accounts.User
    belongs_to :club, Bookclub.Content.Club

    timestamps()
  end

  @doc false
  def changeset(rate, attrs) do
    rate
    |> cast(attrs, [:user_id, :club_id, :rating, :comment])
    |> validate_required([:user_id, :club_id, :rating, :comment])
    |> validate_inclusion(:rating, 1..5)
  end
end

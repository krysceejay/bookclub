defmodule Bookclub.Content.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :rating, :integer
    field :comment, :string
    belongs_to :user, Bookclub.Accounts.User
    belongs_to :book, Bookclub.Content.Book

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:user_id, :book_id, :rating, :comment])
    |> validate_required([:user_id, :book_id, :rating, :comment])
  end
end

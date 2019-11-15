defmodule Bookclub.Content.Reader do
  use Ecto.Schema
  import Ecto.Changeset

  schema "readers" do
    field :status, :boolean, default: true

    belongs_to :user, Bookclub.Accounts.User
    belongs_to :book, Bookclub.Content.Book

    timestamps()
  end

  @doc false
  def changeset(reader, attrs) do
    reader
    |> cast(attrs, [:user_id, :book_id, :status])
    |> validate_required([:user_id, :book_id])
  end
end

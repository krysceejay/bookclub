defmodule Bookclub.Messages.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    field :message, :string

    belongs_to :user, Bookclub.Accounts.User
    belongs_to :book, Bookclub.Content.Book

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:user_id, :book_id, :message])
    |> validate_required([:user_id, :book_id, :message])
  end
end

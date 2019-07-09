defmodule Bookclub.Content.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :author, :string
    field :bookcover, :string
    field :description, :string
    field :genre, {:array, :string}
    field :link, :string
    field :published, :boolean, default: false
    field :title, :string
    #field :user_id, :id
    belongs_to :user, Bookclub.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author, :genre, :bookcover, :link, :description, :published])
    |> validate_required([:title, :author, :genre, :bookcover, :link, :description, :published])
  end
  # 
  # def uploadfile do
  #
  # end

end

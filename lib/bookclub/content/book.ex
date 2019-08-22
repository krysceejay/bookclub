defmodule Bookclub.Content.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :title}

  schema "books" do
    field :author, :string
    field :bookcover, :string
    field :description, :string
    field :genre, {:array, :string}
    field :link, :string
    field :published, :boolean, default: false
    field :title, :string
    #Virtual Fields
    field :bookcover_field, :string, virtual: true

    belongs_to :user, Bookclub.Accounts.User
    has_many :chats, Bookclub.Messages.Chat

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do

    book
    |> cast(attrs, [:title, :author, :genre, :link, :description, :published, :user_id])
    |> validate_required([:title, :author, :genre, :link, :description, :published, :user_id])
    |> uploadfile(attrs)
    |> slug_map(attrs)
  end

  defp uploadfile(changeset, attrs) do
    if upload = attrs["bookcover_field"] do
      extension = Path.extname(upload.filename)
      time = DateTime.utc_now |> DateTime.to_unix
      filename = Path.basename(upload.filename, extension)
      newFilename = "#{filename}_#{time}#{extension}"
      File.cp!(upload.path, "priv/static/images/bookcover/#{newFilename}")

      put_change(changeset, :bookcover, newFilename)

    else
      put_change(changeset, :bookcover, "noimage.jpg")
    end

  end

  defp slug_map(changeset, attrs) do
    # %{"slug" => slug}
    if title = attrs["title"] do
      slug = String.downcase(title) |> String.replace(" ", "-")

      put_change(changeset, :bslug, slug)

      changeset
    else

      changeset
    end
  end

end

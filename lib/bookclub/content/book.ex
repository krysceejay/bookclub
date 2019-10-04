defmodule Bookclub.Content.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :slug}

  schema "books" do
    field :author, :string
    field :bookcover, :string
    field :description, :string
    field :genre, {:array, :string}
    field :published, :boolean, default: false
    field :title, :string
    field :slug, :string
    field :meeting_date, :string
    field :meeting_time, :time
    #Virtual Fields
    field :bookcover_field, :string, virtual: true

    belongs_to :user, Bookclub.Accounts.User
    has_many :chats, Bookclub.Messages.Chat

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do

    book
    |> cast(attrs, [:title, :author, :genre, :description, :published, :user_id, :meeting_date, :meeting_time])
    |> validate_required([:title, :author, :genre, :description, :published, :user_id, :meeting_date, :meeting_time])
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
      put_change(changeset, :slug, "#{slug}-#{DateTime.utc_now |> DateTime.to_unix}")
    else
      changeset
    end
  end

end

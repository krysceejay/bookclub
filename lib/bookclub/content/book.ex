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
    field :public, :boolean, default: true
    field :title, :string
    field :slug, :string
    field :meeting_date, :string
    field :meeting_time, :time
    # Virtual Fields
    field :bookcover_field, :string, virtual: true

    belongs_to :user, Bookclub.Accounts.User
    has_many :chats, Bookclub.Messages.Chat
    has_many :readers, Bookclub.Content.Reader
    has_many :ratings, Bookclub.Content.Rating
    has_many :topics, Bookclub.Content.Topic

    timestamps()
  end

  @doc false
  def changeset(book, attrs, bk \\ %{}) do
    book
    |> cast(attrs, [
      :title,
      :author,
      :genre,
      :description,
      :published,
      :public,
      :user_id,
      :meeting_date,
      :meeting_time
    ])
    |> validate_required([
      :title,
      :author,
      :genre,
      :description,
      :published,
      :public,
      :user_id,
      :meeting_date,
      :meeting_time
    ])
    |> uploadfile(attrs, bk)
    |> slug_map(attrs, bk)
  end

  defp uploadfile(changeset, attrs, bk) do
    if upload = attrs["bookcover_field"] do
      extension = Path.extname(upload.filename)
      time = DateTime.utc_now() |> DateTime.to_unix()
      filename = Path.basename(upload.filename, extension)
      newFilename = "#{filename}_#{time}#{extension}"
      File.cp!(upload.path, "priv/static/images/bookcover/#{newFilename}")

      if bk != %{} do
        if bk.bookcover != "noimage.jpg" do
          File.rm("priv/static/images/bookcover/#{bk.bookcover}")
        end
      end

      put_change(changeset, :bookcover, newFilename)
    else
      if bk == %{} do
        put_change(changeset, :bookcover, "noimage.jpg")
      else
        put_change(changeset, :bookcover, bk.bookcover)
      end
    end
  end

  defp slug_map(changeset, attrs, bk) do
    # %{"slug" => slug}

    if title = attrs["title"] do
      if bk != %{} do
        put_change(changeset, :slug, bk.slug)
      else
        slug = String.downcase(title) |> String.replace(" ", "-")
        put_change(changeset, :slug, "#{slug}-#{DateTime.utc_now() |> DateTime.to_unix()}")
      end

    else
      changeset
    end
  end
end

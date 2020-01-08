defmodule Bookclub.Content.Book do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bookclub.Upload

  @derive {Phoenix.Param, key: :slug}

  @upload_directory Application.get_env(:bookclub, :uploads_directory)

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

  def changeset_c(book, attrs) do
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
    |> upload_oncreation(attrs)
    |> slug_map_c(attrs)
  end

  defp uploadfile(changeset, attrs, bk) do
    if attrs["bookcover_field"] do
      uploadFileName =
        Upload.create_upload_from_plug_upload(attrs["bookcover_field"], "bookcover", "noimage.jpg")

        if bk.bookcover != "noimage.jpg" do
          Upload.local_path("bookcover", bk.bookcover) |> File.rm()
        end
      put_change(changeset, :bookcover, uploadFileName)

    else
      if bk == %{} do
        put_change(changeset, :bookcover, "noimage.jpg")
      else
        put_change(changeset, :bookcover, bk.bookcover)
      end
    end
  end

  defp upload_oncreation(changeset, attrs) do
    if attrs["bookcover_field"] do

      uploadFileName =
        Upload.create_upload_from_plug_upload(attrs["bookcover_field"], "bookcover", "noimage.jpg")
      put_change(changeset, :bookcover, uploadFileName)
    else
      put_change(changeset, :bookcover, "noimage.jpg")
    end
  end

  defp slug_map(changeset, attrs, bk) do
    # %{"slug" => slug}

    if title = attrs["title"] do
      if bk.title == title do
        put_change(changeset, :slug, bk.slug)
      else
        slug = String.downcase(title) |> String.replace(" ", "-")
        put_change(changeset, :slug, "#{slug}-#{DateTime.utc_now() |> DateTime.to_unix()}")
      end

    else
      changeset
    end
  end

  defp slug_map_c(changeset, attrs) do
    if title = attrs["title"] do
      slug = String.downcase(title) |> String.replace(" ", "-")
      put_change(changeset, :slug, "#{slug}-#{DateTime.utc_now() |> DateTime.to_unix()}")
    else
      changeset
    end
  end


end

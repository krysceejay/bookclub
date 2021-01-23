defmodule Bookclub.Content.FeaturedBook do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bookclub.Upload

  schema "featured_books" do
    field :title, :string
    field :author, :string
    field :bookcover, :string
    field :description, :string
    field :status, :boolean, default: true

    # Virtual Fields
    field :bookcover_field, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(featured_book, attrs) do
    featured_book
    |> cast(attrs, [:title, :author, :description, :status])
    |> validate_required([:title, :author, :description, :status])
    |> upload_oncreation(attrs)
  end

  defp upload_oncreation(changeset, attrs) do
    if attrs["bookcover_field"] do
      uploadFileName =
        Upload.create_upload_from_plug_upload(attrs["bookcover_field"], "featured", "noimage.png")
      put_change(changeset, :bookcover, uploadFileName)
    else
      put_change(changeset, :bookcover, "noimage.png")
    end
  end
end

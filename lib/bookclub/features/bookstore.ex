defmodule Bookclub.Features.Bookstore do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bookclub.Upload

  schema "bookstores" do
    field :name, :string
    field :address, :string
    field :email, :string
    field :phone, :string
    field :displayimg, :string
    field :description, :string
    field :status, :boolean, default: true

    # Virtual Fields
    field :displayimg_field, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(bookstore, attrs) do
    bookstore
    |> cast(attrs, [:name, :address, :email, :phone, :description, :status])
    |> validate_required([:name, :address, :email, :phone, :description])
    |> upload_oncreation(attrs)
  end

  defp upload_oncreation(changeset, attrs) do
    if attrs["displayimg_field"] do
      uploadFileName =
        Upload.create_upload_from_plug_upload(attrs["displayimg_field"], "featured", "noimage.png")
      put_change(changeset, :displayimg, uploadFileName)
    else
      put_change(changeset, :displayimg, "noimage.png")
    end
  end
end

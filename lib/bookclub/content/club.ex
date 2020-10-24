defmodule Bookclub.Content.Club do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clubs" do
    field :image, :string
    field :name, :string
    field :public, :boolean, default: true

    # Virtual Fields
    field :image_field, :string, virtual: true

    belongs_to :user, Bookclub.Accounts.User

    timestamps()
  end

  @doc false
  def changeset_c(club, attrs) do
    club
    |> cast(attrs, [:name, :public, :user_id])
    |> validate_required([:name, :public, :user_id])
    |> unique_constraint(:name)
    |> upload_oncreation(attrs)
  end


  defp upload_oncreation(changeset, attrs) do
    if attrs["image_field"] do

      uploadFileName =
        Upload.create_upload_from_plug_upload(attrs["image_field"], "club", "noimage.jpg")
      put_change(changeset, :image, uploadFileName)

    else
      put_change(changeset, :image, "noimage.jpg")
    end
  end

end

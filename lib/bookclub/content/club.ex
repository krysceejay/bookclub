defmodule Bookclub.Content.Club do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bookclub.Upload

  schema "clubs" do
    field :image, :string
    field :name, :string
    field :public, :boolean, default: true
    field :description, :string
    field :details, :string
    field :genre, {:array, :string}
    field :publish, :boolean, default: false
    field :feat, :boolean, default: false

    # Virtual Fields
    field :image_field, :string, virtual: true

    belongs_to :user, Bookclub.Accounts.User
    has_many :members, Bookclub.Content.Member
    has_many :rates, Bookclub.Content.Rate
    has_many :polls, Bookclub.Content.Poll
    has_many :lists, Bookclub.Content.List
    has_many :reports, Bookclub.Content.Report
    has_many :favorites, Bookclub.Content.Favorite

    timestamps()
  end

  @doc false
  def changeset_c(club, attrs) do
    club
    |> cast(attrs, [:name, :public, :user_id, :description, :details, :genre, :publish])
    |> validate_required([:name, :public, :user_id, :description, :genre, :publish])
    |> unique_constraint(:name)
    |> upload_oncreation(attrs)
  end

  def changeset_app(club, attrs) do
    club
    |> cast(attrs, [:name, :public, :user_id, :description, :details, :genre, :publish, :image])
    |> validate_required([:name, :public, :user_id, :description, :genre, :publish, :image])
    |> unique_constraint(:name)
  end

  def set_public(club, attrs) do
    club
    |> cast(attrs, [:public])
  end

  def set_publish(club, attrs) do
    club
    |> cast(attrs, [:publish])
  end

  def set_featured(club, attrs) do
    club
    |> cast(attrs, [:feat])
  end


  defp upload_oncreation(changeset, attrs) do
    if attrs["image_field"] do

      uploadFileName =
        Upload.create_upload_from_plug_upload(attrs["image_field"], "club", "noimage.png")
      put_change(changeset, :image, uploadFileName)

    else
      put_change(changeset, :image, "noimage.png")
    end
  end

end

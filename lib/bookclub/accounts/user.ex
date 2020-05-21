defmodule Bookclub.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bookclub.Accounts.Encryption
  alias Bookclub.Upload

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :status, :integer
    field :username, :string
    field :about, :string
    field :propix, :string
    field :colour, :string
    #field :role_id, :id
    belongs_to :role, Bookclub.Accounts.Role
    has_many :books, Bookclub.Content.Book
    has_many :chats, Bookclub.Messages.Chat
    has_many :readers, Bookclub.Content.Reader
    has_many :ratings, Bookclub.Content.Rating
    has_one :verify, Bookclub.Accounts.Verify

    ##Virtual Fields ##
    field :passwordfield, :string, virtual: true
    field :propix_field, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :username, :passwordfield])
    |> validate_required([:first_name, :last_name, :email, :username, :passwordfield])
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:passwordfield, min: 6, max: 100)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> encrypt_password
    |> default_pic
  end

  def changeset_update(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :username, :about, :colour])
    |> validate_required([:first_name, :last_name, :username])
    |> unique_constraint(:username)
    |> uploadfile(attrs, user)
  end

  def changeset_for_status(user, attrs) do
    user
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end

  def changeset_password_reset(user, attrs) do
    user
    |> cast(attrs, [:passwordfield])
    |> validate_required([:passwordfield])
    |> validate_length(:passwordfield, min: 6, max: 100)
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :passwordfield)

    if password do
      encrypted_password = Encryption.hash_password(password).password_hash

      put_change(changeset, :password, encrypted_password)

    else
      changeset
    end

  end

  defp uploadfile(changeset, attrs, pr) do

    if attrs["propix_field"] do

      uploadFileName =
        Upload.create_upload_from_plug_upload(attrs["propix_field"], "profiles", "noimage.png")

      if pr.propix != "noimage.png" do
        Upload.local_path("profiles", pr.propix) |> File.rm()
      end

      put_change(changeset, :propix, uploadFileName)
    else
      if pr == %{} do
        put_change(changeset, :propix, "noimage.png")
      else
        put_change(changeset, :propix, pr.propix)
      end
    end
  end

  defp default_pic(changeset) do
    put_change(changeset, :propix, "noimage.png")
  end



end

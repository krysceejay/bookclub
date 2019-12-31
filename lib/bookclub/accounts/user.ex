defmodule Bookclub.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bookclub.Accounts.Encryption

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :status, :integer
    field :username, :string
    field :about, :string
    field :propix, :string
    #field :role_id, :id
    belongs_to :role, Bookclub.Accounts.Role
    has_many :books, Bookclub.Content.Book
    has_many :chats, Bookclub.Messages.Chat
    has_many :readers, Bookclub.Content.Reader
    has_many :ratings, Bookclub.Content.Rating

    ##Virtual Fields ##
    field :passwordfield, :string, virtual: true
    field :passwordfield_confirmation, :string, virtual: true
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
    |> validate_confirmation(:passwordfield)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> encrypt_password
    |> default_pic
  end

  def changeset_update(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :username, :about])
    |> validate_required([:first_name, :last_name, :username])
    |> unique_constraint(:username)
    |> uploadfile(attrs, user)
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

    if upload = attrs["propix_field"] do
      extension = Path.extname(upload.filename)
      time = DateTime.utc_now() |> DateTime.to_unix()
      filename = Path.basename(upload.filename, extension)
      newFilename = "#{filename}_#{time}#{extension}"
      File.cp!(upload.path, "priv/static/images/profiles/#{newFilename}")

      if pr != %{} do
        if pr.propix != "noimage.png" do
          File.rm("priv/static/images/profiles/#{pr.propix}")
        end
      end

      put_change(changeset, :propix, newFilename)
    else
      if pr == %{} do
        put_change(changeset, :propix, "noimage.png")
      else
        put_change(changeset, :propix, pr.propix)
      end
    end
  end

  def default_pic(changeset) do
    put_change(changeset, :propix, "noimage.png")
  end



end

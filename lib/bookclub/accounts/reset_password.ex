defmodule Bookclub.Accounts.ResetPassword do
  use Ecto.Schema
  import Ecto.Changeset

  schema "password_reset" do
    field :email, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(reset_password, attrs) do
    reset_password
    |> cast(attrs, [:email, :token])
    |> validate_required([:email, :token])
    |> unique_constraint(:email)
  end
end

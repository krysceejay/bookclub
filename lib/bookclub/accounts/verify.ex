defmodule Bookclub.Accounts.Verify do
  use Ecto.Schema
  import Ecto.Changeset

  schema "verify_users" do
    field :token, :string
    belongs_to :user, Bookclub.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(verify, attrs) do
    verify
    |> cast(attrs, [:user_id, :token])
    |> validate_required([:user_id, :token])
  end
end

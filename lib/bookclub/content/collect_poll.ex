defmodule Bookclub.Content.CollectPoll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "collectpolls" do
    field :poll_index, :integer
    belongs_to :user, Bookclub.Accounts.User
    belongs_to :poll, Bookclub.Content.Poll

    timestamps()
  end

  @doc false
  def changeset(collect_poll, attrs) do
    collect_poll
    |> cast(attrs, [:user_id, :poll_id, :poll_index])
    |> validate_required([:user_id, :poll_id, :poll_index])
  end
end

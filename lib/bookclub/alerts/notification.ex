defmodule Bookclub.Alerts.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :type, :string
    field :seen, :boolean, default: false
    belongs_to :sender_user, Bookclub.Accounts.User, foreign_key: :sender_user_id
    belongs_to :receiver_user, Bookclub.Accounts.User, foreign_key: :receiver_user_id
    belongs_to :club, Bookclub.Content.Club

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:type, :sender_user_id, :receiver_user_id, :club_id, :seen])
    |> validate_required([:type, :sender_user_id, :receiver_user_id])
  end
end

defmodule Bookclub.Content.Report do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reports" do
    field :subject, :string
    field :body, :string
    belongs_to :user, Bookclub.Accounts.User
    belongs_to :club, Bookclub.Content.Club

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:user_id, :club_id, :subject, :body])
    |> validate_required([:user_id, :club_id, :subject, :body])
  end
end

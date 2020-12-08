defmodule Bookclub.Content.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    field :poll_name, :string
    field :books, {:array, :string}
    field :current, :boolean, default: false

    belongs_to :club, Bookclub.Content.Club
    has_many :collectpolls, Bookclub.Content.CollectPoll

    timestamps()
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:club_id, :poll_name, :books, :current])
    |> validate_required([:club_id, :poll_name, :books, :current])
  end

  def set_status(poll, attrs) do
    poll
    |> cast(attrs, [:current])
  end

end

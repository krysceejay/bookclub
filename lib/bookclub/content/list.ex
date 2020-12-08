defmodule Bookclub.Content.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :title, :string
    field :bookcover, :string
    field :current, :boolean, default: false

    belongs_to :club, Bookclub.Content.Club

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:club_id, :title, :bookcover, :current])
    |> validate_required([:club_id, :title, :bookcover, :current])
  end

  def set_status(list, attrs) do
    list
    |> cast(attrs, [:current])
  end
end

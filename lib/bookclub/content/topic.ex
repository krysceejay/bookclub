defmodule Bookclub.Content.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :topic_status, :integer, default: 0
    field :topic_text, :string
    belongs_to :book, Bookclub.Content.Book

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:book_id, :topic_text, :topic_status])
    |> validate_required([:book_id, :topic_text])
    |> validate_inclusion(:topic_status, 0..2)
  end
end

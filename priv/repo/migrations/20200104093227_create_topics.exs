defmodule Bookclub.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :topic_text, :text
      add :topic_status, :integer, default: 0
      add :book_id, references(:books, on_delete: :delete_all)

      timestamps()
    end
    create index(:topics, [:book_id])
  end
end

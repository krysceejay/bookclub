defmodule Bookclub.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :message, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :book_id, references(:books, on_delete: :delete_all)

      timestamps()
    end

    create index(:chats, [:user_id])
    create index(:chats, [:book_id])

  end
end

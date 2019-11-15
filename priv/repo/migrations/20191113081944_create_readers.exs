defmodule Bookclub.Repo.Migrations.CreateReaders do
  use Ecto.Migration

  def change do
    create table(:readers) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :book_id, references(:books, on_delete: :delete_all)
      add :status, :boolean, default: true, null: false

      timestamps()
    end

  end
end

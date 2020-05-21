defmodule Bookclub.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :book_id, references(:books, on_delete: :delete_all)
      add :rating, :integer
      add :comment, :text, null: true

      timestamps()
    end

    create index(:ratings, [:user_id])
    create index(:ratings, [:book_id])

  end
end

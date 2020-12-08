defmodule Bookclub.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :club_id, references(:clubs, on_delete: :delete_all)

      timestamps()
    end
    create index(:favorites, [:user_id])
    create index(:favorites, [:club_id])

  end
end

defmodule Bookclub.Repo.Migrations.CreateClubs do
  use Ecto.Migration

  def change do
    create table(:clubs) do
      add :name, :string
      add :image, :string
      add :public, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:clubs, [:name])
    create index(:clubs, [:user_id])
  end
end

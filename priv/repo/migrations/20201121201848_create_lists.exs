defmodule Bookclub.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string
      add :bookcover, :string
      add :current, :boolean, default: false, null: false
      add :club_id, references(:clubs, on_delete: :delete_all)

      timestamps()
    end

    create index(:lists, [:club_id])

  end
end

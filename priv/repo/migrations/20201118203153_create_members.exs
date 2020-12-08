defmodule Bookclub.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :club_id, references(:clubs, on_delete: :delete_all)
      add :status, :boolean, default: true, null: false

      timestamps()
    end
    create index(:members, [:user_id])
    create index(:members, [:club_id])

  end
end

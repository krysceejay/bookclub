defmodule Bookclub.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :username, :string
      add :password, :string
      add :status, :integer, default: 0
      add :about, :text, null: true
      add :propix, :string, null: true
      add :role_id, references(:roles, on_delete: :nothing), null: false, default: 1

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
    create index(:users, [:role_id])
  end
end

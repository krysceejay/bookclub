defmodule Bookclub.Repo.Migrations.CreateRates do
  use Ecto.Migration

  def change do
    create table(:rates) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :club_id, references(:clubs, on_delete: :delete_all)
      add :rating, :integer
      add :comment, :text, null: true

      timestamps()
    end

    create index(:rates, [:user_id])
    create index(:rates, [:club_id])

  end
end

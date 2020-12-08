defmodule Bookclub.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :club_id, references(:clubs, on_delete: :delete_all)
      add :subject, :text, null: true
      add :body, :text, null: true

      timestamps()
    end

    create index(:reports, [:user_id])
    create index(:reports, [:club_id])

  end
end

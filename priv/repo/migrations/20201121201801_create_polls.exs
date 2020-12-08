defmodule Bookclub.Repo.Migrations.CreatePolls do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :poll_name, :string
      add :books, {:array, :string}
      add :current, :boolean, default: false, null: false
      add :club_id, references(:clubs, on_delete: :delete_all)

      timestamps()
    end

    create index(:polls, [:club_id])

  end
end

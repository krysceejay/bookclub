defmodule Bookclub.Repo.Migrations.CreateCollectpolls do
  use Ecto.Migration

  def change do
    create table(:collectpolls) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :poll_id, references(:polls, on_delete: :delete_all)
      add :poll_index, :integer

      timestamps()
    end

    create index(:collectpolls, [:user_id])
    create index(:collectpolls, [:poll_id])

  end
end

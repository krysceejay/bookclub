defmodule Bookclub.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :type, :string
      add :seen, :boolean, default: false, null: false
      add :sender_user_id, references(:users, on_delete: :delete_all)
      add :receiver_user_id, references(:users, on_delete: :delete_all)
      add :club_id, references(:clubs, on_delete: :delete_all), null: true

      timestamps()
    end
    create index(:notifications, [:sender_user_id])
    create index(:notifications, [:receiver_user_id])
    create index(:notifications, [:club_id])
  end
end

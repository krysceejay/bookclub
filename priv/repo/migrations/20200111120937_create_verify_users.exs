defmodule Bookclub.Repo.Migrations.CreateVerifyUsers do
  use Ecto.Migration

  def change do
    create table(:verify_users) do
      add :user_id, references(:users, on_delete: :nothing)
      add :token, :string

      timestamps()
    end

  end
end

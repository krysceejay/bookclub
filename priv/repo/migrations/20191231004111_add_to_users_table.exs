defmodule Bookclub.Repo.Migrations.AddToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :about, :text, null: true
      add :propix, :string, null: true
     end

  end
end

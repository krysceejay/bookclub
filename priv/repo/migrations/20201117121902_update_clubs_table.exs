defmodule Bookclub.Repo.Migrations.UpdateClubsTable do
  use Ecto.Migration

  def change do
    alter table(:clubs) do
      add :genre, {:array, :string}
      add :publish, :boolean, default: false, null: false
      add :description, :text
    end
  end
end

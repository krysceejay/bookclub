defmodule Bookclub.Repo.Migrations.AddFeatToClub do
  use Ecto.Migration

  def change do
    alter table(:clubs) do
      add :feat, :boolean, default: false, null: false
    end
  end
end

defmodule Bookclub.Repo.Migrations.AddDetailsToClub do
  use Ecto.Migration

  def change do
    alter table(:clubs) do
      add :details, :text, null: true
    end
  end
end

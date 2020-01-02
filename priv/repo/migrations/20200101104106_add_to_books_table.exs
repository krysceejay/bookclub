defmodule Bookclub.Repo.Migrations.AddToBooksTable do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :public, :boolean, default: true, null: false
     end
  end
end

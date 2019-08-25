defmodule Bookclub.Repo.Migrations.AddSlugToBooksTable do
  use Ecto.Migration

  def change do
    alter table(:books) do
        add :slug, :string
      end
  end
end

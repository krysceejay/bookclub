defmodule Bookclub.Repo.Migrations.CreateFeaturedBooks do
  use Ecto.Migration

  def change do
    create table(:featured_books) do
      add :title, :string
      add :author, :string
      add :bookcover, :string
      add :description, :text
      add :status, :boolean, default: true, null: false

      timestamps()
    end

  end
end

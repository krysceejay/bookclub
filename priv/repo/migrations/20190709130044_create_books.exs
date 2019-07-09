defmodule Bookclub.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :author, :string
      add :genre, {:array, :string}
      add :bookcover, :string
      add :link, :text
      add :description, :text
      add :published, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:books, [:user_id])
  end
end

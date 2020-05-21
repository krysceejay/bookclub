defmodule Bookclub.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :author, :string
      add :genre, {:array, :string}
      add :bookcover, :string
      add :description, :text
      add :meeting_date, :string
      add :meeting_time, :time
      add :slug, :string
      add :published, :boolean, default: false, null: false
      add :public, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:books, [:user_id])
  end
end

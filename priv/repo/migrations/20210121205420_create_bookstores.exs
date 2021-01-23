defmodule Bookclub.Repo.Migrations.CreateBookstores do
  use Ecto.Migration

  def change do
    create table(:bookstores) do
      add :name, :string
      add :address, :string
      add :email, :string, null: true
      add :phone, :string, null: true
      add :displayimg, :string
      add :description, :text
      add :status, :boolean, default: true, null: false

      timestamps()
    end

  end
end

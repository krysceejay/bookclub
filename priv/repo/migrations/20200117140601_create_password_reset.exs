defmodule Bookclub.Repo.Migrations.CreatePasswordReset do
  use Ecto.Migration

  def change do
    create table(:password_reset) do
      add :email, :string
      add :token, :string

      timestamps()
    end

    create unique_index(:password_reset, [:email])
  end
end

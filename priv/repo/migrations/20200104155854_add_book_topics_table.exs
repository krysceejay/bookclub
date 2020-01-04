defmodule Bookclub.Repo.Migrations.AddBookTopicsTable do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :topic_status, :integer, default: 0
     end
  end
end

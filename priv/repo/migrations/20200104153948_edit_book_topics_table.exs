defmodule Bookclub.Repo.Migrations.EditBookTopicsTable do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      remove :topic_status
     end
  end
end

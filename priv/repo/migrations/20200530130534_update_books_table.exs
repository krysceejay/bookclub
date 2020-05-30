defmodule Bookclub.Repo.Migrations.UpdateBooksTable do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :meeting_details, :text
      remove :meeting_date
      remove :meeting_time
    end
  end
end

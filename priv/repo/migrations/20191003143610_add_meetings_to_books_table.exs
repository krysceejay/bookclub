defmodule Bookclub.Repo.Migrations.AddMeetingsToBooksTable do
  use Ecto.Migration

  def change do
    alter table(:books) do
        add :meeting_date, :string
        
      end
  end
end

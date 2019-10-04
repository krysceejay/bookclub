defmodule Bookclub.Repo.Migrations.AddMeetingToBooksTable do
  use Ecto.Migration

  def change do
    alter table(:books) do
        add :meeting_date, :utc_datetime
        add :meeting_time, :time
        remove :link
      end
  end
end

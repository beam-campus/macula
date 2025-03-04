defmodule Swai.Repo.Migrations.AddUserLastSeen do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :last_seen, :utc_datetime_usec
    end
  end
end

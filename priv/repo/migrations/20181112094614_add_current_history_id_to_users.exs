defmodule Comindivion.Repo.Migrations.AddCurrentHistoryIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :current_history_id, references(:history, on_delete: :nilify_all, type: :uuid)
    end

    create index(:users, [:current_history_id])
  end
end

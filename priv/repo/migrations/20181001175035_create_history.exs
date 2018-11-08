defmodule Comindivion.Repo.Migrations.CreateHistory do
  use Ecto.Migration

  def change do
    create table(:history, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid, null: false)
      add :previous_history_id, references(:history, on_delete: :delete_all, type: :uuid)
      add :diff, :json, null: false

      timestamps()
    end

    create index(:history, [:user_id])
    create index(:history, [:previous_history_id])
  end
end

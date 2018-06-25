defmodule Comindivion.Repo.Migrations.AddUserIdToMindObject do
  use Ecto.Migration

  def change do
    alter table(:mind_objects) do
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)
    end
  end
end

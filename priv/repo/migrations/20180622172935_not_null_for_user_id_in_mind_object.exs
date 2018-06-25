defmodule Comindivion.Repo.Migrations.NotNullForUserIdInMindObject do
  use Ecto.Migration

  def change do
    alter table(:mind_objects) do
      modify :user_id, :uuid, null: false
    end
  end
end

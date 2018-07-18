defmodule Comindivion.Repo.Migrations.NotNullForAllFieldsInPosition do
  use Ecto.Migration

  def change do
    alter table(:positions) do
      modify :mind_object_id, :uuid, null: false
      modify :x, :float, null: false
      modify :y, :float, null: false
    end
  end
end

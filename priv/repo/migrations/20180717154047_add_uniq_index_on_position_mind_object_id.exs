defmodule Comindivion.Repo.Migrations.AddUniqIndexOnPositionMindObjectId do
  use Ecto.Migration

  def change do
    create unique_index(:positions, [:mind_object_id])
  end
end

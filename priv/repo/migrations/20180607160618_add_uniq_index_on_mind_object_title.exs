defmodule Comindivion.Repo.Migrations.AddUniqIndexOnMindObjectTitle do
  use Ecto.Migration

  def change do
    create unique_index(:mind_objects, [:title])
  end
end

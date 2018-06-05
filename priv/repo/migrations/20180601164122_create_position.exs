defmodule Comindivion.Repo.Migrations.CreatePosition do
  use Ecto.Migration

  def change do
    create table(:positions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :mind_object_id, references(:mind_objects, on_delete: :delete_all, type: :uuid)
      add :x, :float
      add :y, :float

      timestamps()
    end
  end
end

defmodule Comindivion.Repo.Migrations.CreateSubjectObjectRelation do
  use Ecto.Migration

  def change do
    create table(:subject_object_relations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :subject_id, references(:mind_objects, on_delete: :nothing, type: :uuid)
      add :object_id, references(:mind_objects, on_delete: :nothing, type: :uuid)
      add :predicate_id, references(:predicates, on_delete: :nothing, type: :uuid)

      timestamps()
    end
    create index(:subject_object_relations, [:subject_id])
    create index(:subject_object_relations, [:object_id])
    create index(:subject_object_relations, [:predicate_id])

  end
end

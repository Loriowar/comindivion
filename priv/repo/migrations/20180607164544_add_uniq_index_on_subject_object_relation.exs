defmodule Comindivion.Repo.Migrations.AddUniqIndexOnSubjectObjectRelation do
  use Ecto.Migration

  def change do
    create unique_index(:subject_object_relations, [:subject_id, :object_id, :predicate_id], name: :subject_object_relation_uniqueness_index)
  end
end

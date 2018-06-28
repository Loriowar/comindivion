defmodule Comindivion.Repo.Migrations.NotNullForUserIdInSubjectObjectRelation do
  use Ecto.Migration

  def change do
    alter table(:subject_object_relations) do
      modify :user_id, :uuid, null: false
    end
  end
end

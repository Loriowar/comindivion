defmodule Comindivion.Repo.Migrations.AddUserIdToSubjectObjectRelation do
  use Ecto.Migration

  def change do
    alter table(:subject_object_relations) do
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)
    end
  end
end

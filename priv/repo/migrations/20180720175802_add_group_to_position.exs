defmodule Comindivion.Repo.Migrations.AddUserIdToSubjectObjectRelation do
  use Ecto.Migration

  def change do
    alter table(:positions) do
      add :group, :text
    end

    create index(:positions, [:group])
  end
end

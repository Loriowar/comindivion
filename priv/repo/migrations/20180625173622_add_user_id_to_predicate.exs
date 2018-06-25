defmodule Comindivion.Repo.Migrations.AddUserIdToPredicate do
  use Ecto.Migration

  def change do
    alter table(:predicates) do
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)
    end
  end
end

defmodule Comindivion.Repo.Migrations.NotNullForUserIdInPredicate do
  use Ecto.Migration

  def change do
    alter table(:predicates) do
      modify :user_id, :uuid, null: false
    end
  end
end

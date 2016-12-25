defmodule Comindivion.Repo.Migrations.CreatePredicate do
  use Ecto.Migration

  def change do
    create table(:predicates, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :text

      timestamps()
    end

  end
end

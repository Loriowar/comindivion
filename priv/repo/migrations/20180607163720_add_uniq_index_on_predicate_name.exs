defmodule Comindivion.Repo.Migrations.AddUniqIndexOnPredicateName do
  use Ecto.Migration

  def change do
    create unique_index(:predicates, [:name])
  end
end

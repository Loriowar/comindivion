defmodule Comindivion.Repo.Migrations.AddUriToMindObjects do
  use Ecto.Migration

  def change do
    alter table(:mind_objects) do
      add :uri, :text
    end
  end
end

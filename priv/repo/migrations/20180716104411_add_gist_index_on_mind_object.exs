defmodule Comindivion.Repo.Migrations.AddGistIndexOnMindObject do
  use Ecto.Migration

  def change do
    create index(:mind_objects, ["title gist_trgm_ops"], [
      name: "index_mind_objects_trgm_on_title",
      using: "GIST"
    ])
    create index(:mind_objects, ["content gist_trgm_ops"], [
      name: "index_mind_objects_trgm_on_content",
      using: "GIST"
    ])
  end
end

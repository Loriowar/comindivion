defmodule Comindivion.Repo.Migrations.AddPgTrgmExtension do
  use Ecto.Migration

  def up do
    execute """
      create extension pg_trgm;
    """
  end

  def down do
    execute """
      drop extension pg_trgm;
    """
  end
end

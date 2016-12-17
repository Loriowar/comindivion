defmodule Comindivion.Repo.Migrations.CreateMindObject do
  use Ecto.Migration

  def change do
    create table(:mind_objects, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :text
      add :content, :text
      add :number, :decimal
      add :date, :date
      add :datetime, :datetime
      add :data, :binary

      timestamps()
    end

  end
end

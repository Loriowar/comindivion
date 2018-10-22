defmodule Comindivion.Repo.Migrations.ChangeDefaultValueForGroupFromPosition do
  use Ecto.Migration

  import Ecto.Query

  def up do
    from(p in "positions",
           update: [set: [group: "default"]],
           where: p.group == "" or is_nil(p.group))
    |> Comindivion.Repo.update_all([])

    alter table(:positions) do
      modify :group, :text, default: "default", null: false
    end
  end

  def down do
    alter table(:positions) do
      modify :group, :text, default: '', null: false
    end
  end
end

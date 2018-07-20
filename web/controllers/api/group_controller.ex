defmodule Comindivion.Api.GroupController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject
  alias Comindivion.Position

  import Ecto.Query, only: [from: 2]

  def bulk_update(conn, %{"mind_object_ids" => mind_object_ids, "group" => group}) do
    result =
      from(p in Position,
             join: mo in ^current_user_query(conn, MindObject), on: p.mind_object_id == mo.id,
             where: mo.id in ^mind_object_ids)
      |> Repo.update_all(set: [group: group])
    # TODO: implement status processing
    conn |> put_status(200) |> text("OK")
  end
end

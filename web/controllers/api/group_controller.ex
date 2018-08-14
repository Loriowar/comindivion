defmodule Comindivion.Api.GroupController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject
  alias Comindivion.Position

  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    groups =
      from(p in Position,
           join: mo in ^current_user_query(conn, MindObject), on: p.mind_object_id == mo.id,
           where: not is_nil(p.group),
           order_by: p.group,
           distinct: true,
           select: p.group)
      |> Repo.all
    render(conn, "show.json", groups: groups)
  end

  def bulk_update(conn, %{"mind_object_ids" => mind_object_ids, "group" => group}) do
    positions_query =
      from p in Position,
           join: mo in ^current_user_query(conn, MindObject), on: p.mind_object_id == mo.id,
           where: mo.id in ^mind_object_ids
    expected_count = Repo.aggregate(positions_query, :count, :id)

    {result_count, positions} = Repo.update_all(positions_query, [set: [group: group]], [returning: true])

    if result_count == expected_count do
      result_data = %{positions: positions}

      Comindivion.Endpoint.broadcast(
        "interactive:#{current_user_id(conn)}",
        "interactive:network:node_groups:update",
        Comindivion.Serializer.Interactive.Position.json(result_data))

      render(conn, "show.json", result_data)
    else
      # TODO: try to sent some usable error message
      conn |> put_status(422) |> text("Unprocessable entity")
    end
  end
end

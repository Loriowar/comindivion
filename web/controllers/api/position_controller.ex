defmodule Comindivion.Api.PositionController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject
  alias Comindivion.Position

  import Ecto.Query, only: [from: 2]

  # NOTE: if node created on interactive view it already has position,
  #       otherwise there is no position for node and we must create it
  def update(conn, %{"mind_object_id" => mind_object_id, "position" => position_params}) do
    mind_object_user_id = Repo.get!(MindObject, mind_object_id).user_id
    if mind_object_user_id == current_user_id(conn) do
      position = %Position{mind_object_id: mind_object_id} |> Position.changeset(position_params)

      case Repo.insert(position, on_conflict: :replace_all, conflict_target: :mind_object_id) do
        {:ok, position} ->
          render(conn, "show.json", position: position)
        {:error, changeset} ->
          conn |> put_status(422) |> render("show.json", changeset: changeset)
      end
    else
      conn |> put_status(422) |> text("Unprocessable entity")
    end
  end

  def bulk_update(conn, %{"mind_objects" => mind_objects}) do
    mind_object_ids = Map.keys(mind_objects)
    allowed_mind_object_ids =
      from(p in Position,
             join: mo in ^current_user_query(conn, MindObject), on: p.mind_object_id == mo.id,
             where: mo.id in ^mind_object_ids,
             select: [mo.id])
      |> Repo.all
      |> List.flatten
    position_changesets =
      Enum.map(allowed_mind_object_ids,
        fn(mind_object_id) ->
          Position.changeset(
            %Position{mind_object_id: mind_object_id},
            mind_objects[mind_object_id]
          )
        end
      )

    result =
      position_changesets
      |> Enum.reduce(Ecto.Multi.new, fn(changeset, multi) ->
                                       Ecto.Multi.insert(multi,
                                                         changeset.data.mind_object_id,
                                                         changeset,
                                                         on_conflict: :replace_all,
                                                         conflict_target: :mind_object_id)
                                     end)
      |> Repo.transaction

    case result do
      {:ok, multi_position_result }  ->
        render(conn, "show.json", positions: Map.values(multi_position_result))
      {:error, _, changeset, _ } ->
        render(conn, "show.json", changeset: changeset)
    end
  end
end

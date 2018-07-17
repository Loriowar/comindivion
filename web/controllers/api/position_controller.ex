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
end

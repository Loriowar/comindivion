defmodule Comindivion.Api.PositionController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject
  alias Comindivion.Position

  import Ecto.Query, only: [from: 2]

  # NOTE: if node created on interactive view it already has position,
  #       otherwise there is no position for node and we must create it
  def update(conn, %{"mind_object_id" => mind_object_id, "position" => position_params}) do
    position_relations_query = from p in Position,
                                    join: mo in MindObject, on: mo.id == p.mind_object_id,
                                    where: mo.id == ^mind_object_id,
                                    limit: 1
    position =
      case Repo.one(position_relations_query) do
        nil -> %Position{mind_object_id: mind_object_id}
        position -> position
      end

    case Position.changeset(position, position_params) |> Repo.insert_or_update do
      {:ok, position} ->
        render(conn, "show.json", position: position)
      {:error, changeset} ->
        render(conn, "show.json", changeset: changeset)
    end
  end
end

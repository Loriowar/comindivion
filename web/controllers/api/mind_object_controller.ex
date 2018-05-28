defmodule Comindivion.Api.MindObjectController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject

  def show(conn, %{"id" => id}) do
    mind_object = Repo.get!(MindObject, id)
    render(conn, "show.json", mind_object: mind_object)
  end

  def create(conn, %{"mind_object" => mind_object_params}) do
    changeset = MindObject.changeset(%MindObject{}, mind_object_params)

    case Repo.insert(changeset) do
      {:ok, mind_object} ->
        render(conn, "show.json", mind_object: mind_object)
      {:error, changeset} ->
        render(conn, "show.json", changeset: changeset)
    end
  end
end

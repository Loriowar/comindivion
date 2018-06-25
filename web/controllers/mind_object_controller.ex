defmodule Comindivion.MindObjectController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject

  def index(conn, _params) do
    mind_objects = Repo.all(MindObject)
    render(conn, "index.html", mind_objects: mind_objects)
  end

  def new(conn, _params) do
    changeset = MindObject.changeset(%MindObject{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"mind_object" => mind_object_params}) do
    changeset = MindObject.changeset(%MindObject{user_id: current_user_id(conn)}, mind_object_params)

    case Repo.insert(changeset) do
      {:ok, _mind_object} ->
        conn
        |> put_flash(:info, "Mind object created successfully.")
        |> redirect(to: mind_object_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    mind_object = Repo.get!(MindObject, id)
    render(conn, "show.html", mind_object: mind_object)
  end

  def edit(conn, %{"id" => id}) do
    mind_object = Repo.get!(MindObject, id)
    changeset = MindObject.changeset(mind_object)
    render(conn, "edit.html", mind_object: mind_object, changeset: changeset)
  end

  def update(conn, %{"id" => id, "mind_object" => mind_object_params}) do
    mind_object = Repo.get!(MindObject, id)
    changeset = MindObject.changeset(mind_object, mind_object_params)

    case Repo.update(changeset) do
      {:ok, mind_object} ->
        conn
        |> put_flash(:info, "Mind object updated successfully.")
        |> redirect(to: mind_object_path(conn, :show, mind_object))
      {:error, changeset} ->
        render(conn, "edit.html", mind_object: mind_object, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    mind_object = Repo.get!(MindObject, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(mind_object)

    conn
    |> put_flash(:info, "Mind object deleted successfully.")
    |> redirect(to: mind_object_path(conn, :index))
  end
end

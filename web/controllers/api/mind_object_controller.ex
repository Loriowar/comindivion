defmodule Comindivion.Api.MindObjectController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject

  import Ecto.Query, only: [from: 2]

  def show(conn, %{"id" => id}) do
    mind_objects_query = from m in current_user_query(conn, MindObject),
                              left_join: p in assoc(m, :position),
                              where: m.id == ^id,
                              select: %{id: m.id, title: m.title, content: m.content, uri: m.uri, number: m.number, date: m.date, datetime: m.datetime, group: p.group}

    mind_object = Repo.one(mind_objects_query)
    render(conn, "show.json", mind_object: mind_object)
  end

  def create(conn, %{"mind_object" => mind_object_params}) do
    changeset = MindObject.changeset(%MindObject{user_id: current_user_id(conn)}, mind_object_params)

    case Repo.insert(changeset) do
      {:ok, mind_object} ->
        result_data = %{mind_object: mind_object}

        Comindivion.Endpoint.broadcast(
          "interactive:#{current_user_id(conn)}",
          "interactive:network:node:create",
          Comindivion.Serializer.Interactive.MindObject.json(result_data))

        render(conn, "show.json", result_data)
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "mind_object" => mind_object_params}) do
    mind_object = conn |> current_user_query(MindObject) |> Repo.get!(id)
    changeset = MindObject.changeset(mind_object, mind_object_params)

    case Repo.update(changeset) do
      {:ok, mind_object} ->
        render(conn, "show.json", mind_object: mind_object)
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    mind_object = conn |> current_user_query(MindObject) |> Repo.get!(id)

    case Repo.delete(mind_object) do
      {:ok, mind_object} ->
        render(conn, "show.json", mind_object: mind_object)
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end

  def bulk_delete(conn, %{"mind_object_ids" => ids}) do
    mind_objects_query =
      from(mo in current_user_query(conn, MindObject),
        where: mo.id in ^ids)
    expected_count = Repo.aggregate(mind_objects_query, :count, :id)

    {result_count, mind_objects} = Repo.delete_all(mind_objects_query, returning: true)

    if result_count == expected_count do
      render(conn, "show.json", mind_objects: mind_objects)
    else
      # TODO: try to sent some usable error message
      conn |> put_status(422) |> text("Unprocessable entity")
    end
  end
end

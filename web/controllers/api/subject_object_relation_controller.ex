defmodule Comindivion.Api.SubjectObjectRelationController do
  use Comindivion.Web, :controller

  alias Comindivion.SubjectObjectRelation

  import Ecto.Query, only: [preload: 2]

  def create(conn, %{"subject_object_relation" => subject_object_relation_params}) do
    changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{user_id: current_user_id(conn)}, subject_object_relation_params)

    case Repo.insert(changeset) do
      {:ok, subject_object_relation} ->
        result_data = %{subject_object_relation: subject_object_relation |> Repo.preload([:predicate])}

        Comindivion.Endpoint.broadcast(
          "interactive:#{current_user_id(conn)}",
          "interactive:network:edge:create",
          Comindivion.Serializer.Interactive.SubjectObjectRelation.json(result_data))

        render(conn, "show.json", result_data)
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end

  # NOTE: update only a predicate_id through API request
  def update(conn, %{"id" => id, "subject_object_relation" => %{"predicate_id" => predicate_id}}) do
    subject_object_relation =
      conn
      |> current_user_query(SubjectObjectRelation)
      |> preload([:predicate])
      |> Repo.get!(id)
    # TODO: add a validation on a belonging of a predicate to a current user
    changeset = SubjectObjectRelation.changeset(subject_object_relation, %{predicate_id: predicate_id})

    case Repo.update(changeset) do
      {:ok, subject_object_relation} ->
        result_data = %{subject_object_relation: subject_object_relation}

        Comindivion.Endpoint.broadcast(
          "interactive:#{current_user_id(conn)}",
          "interactive:network:edge:update",
          Comindivion.Serializer.Interactive.SubjectObjectRelation.json(result_data))

        render(conn, "show.json", result_data)
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    subject_object_relation =
      conn
      |> current_user_query(SubjectObjectRelation)
      |> preload([:predicate])
      |> Repo.get!(id)

    case Repo.delete(subject_object_relation) do
      {:ok, subject_object_relation} ->
        result_data = %{subject_object_relation: subject_object_relation}

        Comindivion.Endpoint.broadcast(
          "interactive:#{current_user_id(conn)}",
          "interactive:network:edge:delete",
          Comindivion.Serializer.Interactive.SubjectObjectRelation.json(result_data))

        render(conn, "show.json", result_data)
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end
end

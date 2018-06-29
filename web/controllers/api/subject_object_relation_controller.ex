defmodule Comindivion.Api.SubjectObjectRelationController do
  use Comindivion.Web, :controller

  alias Comindivion.SubjectObjectRelation

  import Ecto.Query, only: [preload: 2]

  def create(conn, %{"subject_object_relation" => subject_object_relation_params}) do
    changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{user_id: current_user_id(conn)}, subject_object_relation_params)

    case Repo.insert(changeset) do
      {:ok, subject_object_relation} ->
        render(conn, "show.json", subject_object_relation: subject_object_relation |> Repo.preload([:predicate]))
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end

  # NOTE: update only a predicate_id through API request
  def update(conn, %{"id" => id, "subject_object_relation" => %{"predicate_id" => predicate_id}}) do
    subject_object_relation = conn |> current_user_query(SubjectObjectRelation) |> preload([:predicate]) |> Repo.get!(id)
    changeset = SubjectObjectRelation.changeset(subject_object_relation, %{predicate_id: predicate_id})

    case Repo.update(changeset) do
      {:ok, mind_object} ->
        render(conn, "show.json", subject_object_relation: subject_object_relation)
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    subject_object_relation = conn |> current_user_query(SubjectObjectRelation) |> preload([:predicate]) |> Repo.get!(id)

    case Repo.delete(subject_object_relation) do
      {:ok, subject_object_relation} ->
        render(conn, "show.json", subject_object_relation: subject_object_relation)
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end
end

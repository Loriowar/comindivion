defmodule Comindivion.Api.SubjectObjectRelationController do
  use Comindivion.Web, :controller

  alias Comindivion.SubjectObjectRelation

  def create(conn, %{"subject_object_relation" => subject_object_relation_params}) do
    changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{}, subject_object_relation_params)

    case Repo.insert(changeset) do
      {:ok, subject_object_relation} ->
        render(conn, "show.json", subject_object_relation: subject_object_relation |> Repo.preload([:predicate]))
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    subject_object_relation = Repo.get!(SubjectObjectRelation, id) |> Repo.preload([:predicate])

    case Repo.delete(subject_object_relation) do
      {:ok, subject_object_relation} ->
        render(conn, "show.json", subject_object_relation: subject_object_relation)
      {:error, changeset} ->
        conn |> put_status(422) |> render("show.json", changeset: changeset)
    end
  end
end

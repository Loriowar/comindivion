defmodule Comindivion.SubjectObjectRelationController do
  use Comindivion.Web, :controller

  alias Comindivion.SubjectObjectRelation
  alias Comindivion.MindObject
  alias Comindivion.Predicate

  def index(conn, _params) do
    subject_object_relations = Repo.all(from s in SubjectObjectRelation, preload: [:subject, :predicate, :object])
    render(conn, "index.html", subject_object_relations: subject_object_relations)
  end

  def new(conn, _params) do
    changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{})
    mind_objects_for_select = Repo.all(MindObject) |> Enum.map(&{&1.title, &1.id})
    predicates_for_select = Repo.all(Predicate) |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset,
                             mind_objects_for_select: mind_objects_for_select,
                             predicates_for_select: predicates_for_select)
  end

  def create(conn, %{"subject_object_relation" => subject_object_relation_params}) do
    changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{}, subject_object_relation_params)

    case Repo.insert(changeset) do
      {:ok, _subject_object_relation} ->
        conn
        |> put_flash(:info, "Subject object relation created successfully.")
        |> redirect(to: subject_object_relation_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    subject_object_relation = Repo.get!(SubjectObjectRelation, id) |> Repo.preload([:subject, :predicate, :object])
    render(conn, "show.html", subject_object_relation: subject_object_relation)
  end

  def edit(conn, %{"id" => id}) do
    subject_object_relation = Repo.get!(SubjectObjectRelation, id)
    changeset = SubjectObjectRelation.changeset(subject_object_relation)
    mind_objects_for_select = Repo.all(MindObject) |> Enum.map(&{&1.title, &1.id})
    predicates_for_select = Repo.all(Predicate) |> Enum.map(&{&1.name, &1.id})
    render(conn, "edit.html", subject_object_relation: subject_object_relation,
                              changeset: changeset,
                              mind_objects_for_select: mind_objects_for_select,
                              predicates_for_select: predicates_for_select)
  end

  def update(conn, %{"id" => id, "subject_object_relation" => subject_object_relation_params}) do
    subject_object_relation = Repo.get!(SubjectObjectRelation, id)
    changeset = SubjectObjectRelation.changeset(subject_object_relation, subject_object_relation_params)

    case Repo.update(changeset) do
      {:ok, subject_object_relation} ->
        conn
        |> put_flash(:info, "Subject object relation updated successfully.")
        |> redirect(to: subject_object_relation_path(conn, :show, subject_object_relation))
      {:error, changeset} ->
        render(conn, "edit.html", subject_object_relation: subject_object_relation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    subject_object_relation = Repo.get!(SubjectObjectRelation, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(subject_object_relation)

    conn
    |> put_flash(:info, "Subject object relation deleted successfully.")
    |> redirect(to: subject_object_relation_path(conn, :index))
  end
end

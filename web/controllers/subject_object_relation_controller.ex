defmodule Comindivion.SubjectObjectRelationController do
  use Comindivion.Web, :controller

  plug Comindivion.Plug.CheckAuth

  alias Comindivion.SubjectObjectRelation
  alias Comindivion.MindObject
  alias Comindivion.Predicate

  import Ecto.Query, only: [preload: 2, select: 3, order_by: 3]

  def index(conn, _params) do
    subject_object_relations =
      conn
      |> current_user_query(SubjectObjectRelation)
      |> preload([:subject, :predicate, :object])
      |> Repo.all
    render(conn, "index.html", subject_object_relations: subject_object_relations)
  end

  def new(conn, _params) do
    changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{})
    mind_objects_for_select =
      conn
      |> current_user_query(MindObject)
      |> select([mo], {mo.title, mo.id})
      |> order_by([mo], [asc: mo.title])
      |> Repo.all
    predicates_for_select =
      conn
      |> current_user_query(Predicate)
      |> select([p], {p.name, p.id})
      |> order_by([p], [asc: p.name])
      |> Repo.all
    render(conn, "new.html", changeset: changeset,
                             mind_objects_for_select: mind_objects_for_select,
                             predicates_for_select: predicates_for_select)
  end

  def create(conn, %{"subject_object_relation" => subject_object_relation_params}) do
    changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{user_id: current_user_id(conn)}, subject_object_relation_params)

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
    subject_object_relation =
      conn
      |> current_user_query(SubjectObjectRelation)
      |> preload([:subject, :predicate, :object])
      |> Repo.get!(id)
    render(conn, "show.html", subject_object_relation: subject_object_relation)
  end

  def edit(conn, %{"id" => id}) do
    subject_object_relation = conn |> current_user_query(SubjectObjectRelation) |> Repo.get!(id)
    changeset = SubjectObjectRelation.changeset(subject_object_relation)
    mind_objects_for_select =
      conn
      |> current_user_query(MindObject)
      |> select([mo], {mo.title, mo.id})
      |> order_by([mo], [asc: mo.title])
      |> Repo.all
    predicates_for_select =
      conn
      |> current_user_query(Predicate)
      |> select([p], {p.name, p.id})
      |> order_by([p], [asc: p.name])
      |> Repo.all
    render(conn, "edit.html", subject_object_relation: subject_object_relation,
                              changeset: changeset,
                              mind_objects_for_select: mind_objects_for_select,
                              predicates_for_select: predicates_for_select)
  end

  def update(conn, %{"id" => id, "subject_object_relation" => subject_object_relation_params}) do
    subject_object_relation = conn |> current_user_query(SubjectObjectRelation) |> Repo.get!(id)
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
    subject_object_relation = conn |> current_user_query(SubjectObjectRelation) |> Repo.get!(id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(subject_object_relation)

    conn
    |> put_flash(:info, "Subject object relation deleted successfully.")
    |> redirect(to: subject_object_relation_path(conn, :index))
  end
end

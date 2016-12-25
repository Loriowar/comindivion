defmodule Comindivion.SubjectObjectRelationControllerTest do
  use Comindivion.ConnCase

  alias Comindivion.SubjectObjectRelation
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, subject_object_relation_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing subject object relations"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, subject_object_relation_path(conn, :new)
    assert html_response(conn, 200) =~ "New subject object relation"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, subject_object_relation_path(conn, :create), subject_object_relation: @valid_attrs
    assert redirected_to(conn) == subject_object_relation_path(conn, :index)
    assert Repo.get_by(SubjectObjectRelation, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, subject_object_relation_path(conn, :create), subject_object_relation: @invalid_attrs
    assert html_response(conn, 200) =~ "New subject object relation"
  end

  test "shows chosen resource", %{conn: conn} do
    subject_object_relation = Repo.insert! %SubjectObjectRelation{}
    conn = get conn, subject_object_relation_path(conn, :show, subject_object_relation)
    assert html_response(conn, 200) =~ "Show subject object relation"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, subject_object_relation_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    subject_object_relation = Repo.insert! %SubjectObjectRelation{}
    conn = get conn, subject_object_relation_path(conn, :edit, subject_object_relation)
    assert html_response(conn, 200) =~ "Edit subject object relation"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    subject_object_relation = Repo.insert! %SubjectObjectRelation{}
    conn = put conn, subject_object_relation_path(conn, :update, subject_object_relation), subject_object_relation: @valid_attrs
    assert redirected_to(conn) == subject_object_relation_path(conn, :show, subject_object_relation)
    assert Repo.get_by(SubjectObjectRelation, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    subject_object_relation = Repo.insert! %SubjectObjectRelation{}
    conn = put conn, subject_object_relation_path(conn, :update, subject_object_relation), subject_object_relation: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit subject object relation"
  end

  test "deletes chosen resource", %{conn: conn} do
    subject_object_relation = Repo.insert! %SubjectObjectRelation{}
    conn = delete conn, subject_object_relation_path(conn, :delete, subject_object_relation)
    assert redirected_to(conn) == subject_object_relation_path(conn, :index)
    refute Repo.get(SubjectObjectRelation, subject_object_relation.id)
  end
end

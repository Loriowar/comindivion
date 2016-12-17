defmodule Comindivion.MindObjectControllerTest do
  use Comindivion.ConnCase

  alias Comindivion.MindObject
  @valid_attrs %{content: "some content", data: "some content", date: %{day: 17, month: 4, year: 2010}, datetime: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, id: "7488a646-e31f-11e4-aace-600308960662", number: "120.5", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, mind_object_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing mind objects"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, mind_object_path(conn, :new)
    assert html_response(conn, 200) =~ "New mind object"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, mind_object_path(conn, :create), mind_object: @valid_attrs
    assert redirected_to(conn) == mind_object_path(conn, :index)
    assert Repo.get_by(MindObject, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, mind_object_path(conn, :create), mind_object: @invalid_attrs
    assert html_response(conn, 200) =~ "New mind object"
  end

  test "shows chosen resource", %{conn: conn} do
    mind_object = Repo.insert! %MindObject{}
    conn = get conn, mind_object_path(conn, :show, mind_object)
    assert html_response(conn, 200) =~ "Show mind object"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, mind_object_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    mind_object = Repo.insert! %MindObject{}
    conn = get conn, mind_object_path(conn, :edit, mind_object)
    assert html_response(conn, 200) =~ "Edit mind object"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    mind_object = Repo.insert! %MindObject{}
    conn = put conn, mind_object_path(conn, :update, mind_object), mind_object: @valid_attrs
    assert redirected_to(conn) == mind_object_path(conn, :show, mind_object)
    assert Repo.get_by(MindObject, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    mind_object = Repo.insert! %MindObject{}
    conn = put conn, mind_object_path(conn, :update, mind_object), mind_object: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit mind object"
  end

  test "deletes chosen resource", %{conn: conn} do
    mind_object = Repo.insert! %MindObject{}
    conn = delete conn, mind_object_path(conn, :delete, mind_object)
    assert redirected_to(conn) == mind_object_path(conn, :index)
    refute Repo.get(MindObject, mind_object.id)
  end
end

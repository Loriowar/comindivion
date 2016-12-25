defmodule Comindivion.PredicateControllerTest do
  use Comindivion.ConnCase

  alias Comindivion.Predicate
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, predicate_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing predicates"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, predicate_path(conn, :new)
    assert html_response(conn, 200) =~ "New predicate"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, predicate_path(conn, :create), predicate: @valid_attrs
    assert redirected_to(conn) == predicate_path(conn, :index)
    assert Repo.get_by(Predicate, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, predicate_path(conn, :create), predicate: @invalid_attrs
    assert html_response(conn, 200) =~ "New predicate"
  end

  test "shows chosen resource", %{conn: conn} do
    predicate = Repo.insert! %Predicate{}
    conn = get conn, predicate_path(conn, :show, predicate)
    assert html_response(conn, 200) =~ "Show predicate"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, predicate_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    predicate = Repo.insert! %Predicate{}
    conn = get conn, predicate_path(conn, :edit, predicate)
    assert html_response(conn, 200) =~ "Edit predicate"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    predicate = Repo.insert! %Predicate{}
    conn = put conn, predicate_path(conn, :update, predicate), predicate: @valid_attrs
    assert redirected_to(conn) == predicate_path(conn, :show, predicate)
    assert Repo.get_by(Predicate, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    predicate = Repo.insert! %Predicate{}
    conn = put conn, predicate_path(conn, :update, predicate), predicate: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit predicate"
  end

  test "deletes chosen resource", %{conn: conn} do
    predicate = Repo.insert! %Predicate{}
    conn = delete conn, predicate_path(conn, :delete, predicate)
    assert redirected_to(conn) == predicate_path(conn, :index)
    refute Repo.get(Predicate, predicate.id)
  end
end

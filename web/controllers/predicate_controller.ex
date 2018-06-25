defmodule Comindivion.PredicateController do
  use Comindivion.Web, :controller

  alias Comindivion.Predicate

  def index(conn, _params) do
    predicates = Repo.all(Predicate)
    render(conn, "index.html", predicates: predicates)
  end

  def new(conn, _params) do
    changeset = Predicate.changeset(%Predicate{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"predicate" => predicate_params}) do
    changeset = Predicate.changeset(%Predicate{user_id: current_user_id(conn)}, predicate_params)

    case Repo.insert(changeset) do
      {:ok, _predicate} ->
        conn
        |> put_flash(:info, "Predicate created successfully.")
        |> redirect(to: predicate_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    predicate = Repo.get!(Predicate, id)
    render(conn, "show.html", predicate: predicate)
  end

  def edit(conn, %{"id" => id}) do
    predicate = Repo.get!(Predicate, id)
    changeset = Predicate.changeset(predicate)
    render(conn, "edit.html", predicate: predicate, changeset: changeset)
  end

  def update(conn, %{"id" => id, "predicate" => predicate_params}) do
    predicate = Repo.get!(Predicate, id)
    changeset = Predicate.changeset(predicate, predicate_params)

    case Repo.update(changeset) do
      {:ok, predicate} ->
        conn
        |> put_flash(:info, "Predicate updated successfully.")
        |> redirect(to: predicate_path(conn, :show, predicate))
      {:error, changeset} ->
        render(conn, "edit.html", predicate: predicate, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    predicate = Repo.get!(Predicate, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(predicate)

    conn
    |> put_flash(:info, "Predicate deleted successfully.")
    |> redirect(to: predicate_path(conn, :index))
  end
end

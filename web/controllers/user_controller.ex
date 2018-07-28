defmodule Comindivion.UserController do
  use Comindivion.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated,
       [handler: Comindivion.Auth.GuardianErrorHandler] when action in [:show]

  alias Comindivion.User

  plug :scrub_params, "user" when action in [:create]

  def show(conn, %{"id" => id}) do
    if current_user_id(conn) == id do
      user = Repo.get!(User, id)
      render(conn, "show.html", user: user)
    else
      # TODO: needs to render template with layout instead of plain text
      conn
      |> put_status(404)
      |> text("Not Found")
    end
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end

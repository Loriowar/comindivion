defmodule Comindivion.SessionController do
  use Comindivion.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated,
       [handler: Comindivion.Auth.GuardianErrorHandler] when action in [:delete]

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Comindivion.User

  plug :scrub_params, "session" when action in [:create]

  def new(conn, _) do
    if current_user_exist?(conn) do
      conn
      |> put_flash(:info, "You're already logged in.")
      |> redirect(to: page_path(conn, :index))
    else
      render conn, "new.html"
    end
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    if current_user_exist?(conn) do
      conn
      |> put_flash(:info, "You're already logged in.")
      |> redirect(to: page_path(conn, :index))
    else
      # try to get user by unique email from DB
      user = Repo.get_by(User, email: email)

      # examine the result
      result = cond do
        # if user was found and provided password hash equals to stored
        # hash
        user && checkpw(password, user.password_hash) ->
          {:ok, login(conn, user)}
        # else if we just found the use
        user ->
          {:error, :unauthorized, conn}
        # otherwise
        true ->
          # simulate check password hash timing
          dummy_checkpw()
          {:error, :not_found, conn}
      end

      case result do
        {:ok, conn} ->
          conn
          |> put_flash(:info, "You’re now logged in!")
          |> redirect(to: page_path(conn, :index))
        {:error, _reason, conn} ->
          conn
          |> put_flash(:error, "Invalid email/password combination")
          |> put_status(401)
          |> render("new.html")
      end
    end
  end

  defp login(conn, user) do
    conn |> Guardian.Plug.sign_in(user)
  end

  def delete(conn, _) do
    conn
    |> logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end

  defp logout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end

defmodule Comindivion.Auth.GuardianErrorHandler do
  import Comindivion.Router.Helpers
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3, text: 2]
  import Plug.Conn, only: [put_status: 2]

  def unauthenticated(conn, _params) do
    case conn.private.phoenix_format do
      "html" ->
        conn
        |> put_flash(:error, "You must be signed in to access that page.")
        |> redirect(to: session_path(conn, :new))
      "json" ->
        conn
        |> put_status(401)
        |> text("Unauthorized")
    end
  end
end
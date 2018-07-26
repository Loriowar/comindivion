defmodule Comindivion.Plug.CheckAuth do
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3, text: 2]
  import Plug.Conn, only: [put_status: 2, halt: 1]

  # NOTE: include of Comindivion.Router.Helpers is a wrong way
  alias Comindivion.Router.Helpers, as: Routes

  def init(opts), do: opts

  # TODO: this method may be simplified
  def call(conn, options) do
    if conn.assigns.current_user == nil do
      case options do
        [only: only] ->
          if Enum.member?(only, conn.private.phoenix_action) do
            redirect_and_halt(conn)
          else
            conn
          end
        [except: except] ->
          if !Enum.member?(except, conn.private.phoenix_action) do
            redirect_and_halt(conn)
          else
            conn
          end
        _ ->
          redirect_and_halt(conn)
      end
    else
      conn
    end
  end

  defp redirect_and_halt(conn) do
    case conn.private.phoenix_format do
      "html" ->
        conn
        |> put_flash(:error, "You must be signed in to access that page.")
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt
      "json" ->
        conn
        |> put_status(401)
        |> text("Unauthorized")
        |> halt
      end
  end
end

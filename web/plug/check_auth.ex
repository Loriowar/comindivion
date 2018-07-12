defmodule Comindivion.Plug.CheckAuth do
  import Phoenix.Controller, only: [redirect: 2, text: 2]
  import Plug.Conn, only: [put_status: 2, halt: 1]

  def init(options) do
    options
  end

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
        |> redirect(to: "/sessions/new")
        |> halt
      "json" ->
        conn
        |> put_status(401)
        |> text("Unauthorized")
        |> halt
      end
  end
end

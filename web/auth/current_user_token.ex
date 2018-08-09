defmodule Comindivion.Auth.CurrentUserToken do
  import Plug.Conn

  import Comindivion.Auth.Constant, only: [salt: 0]

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user =  conn.assigns.current_user
    if current_user do
      token = Phoenix.Token.sign(conn, salt(), current_user.id)
      assign(conn, :current_user_token, token)
    else
      conn
    end
  end
end

defmodule Comindivion.ViewHelper.CurrentUser do
  @moduledoc """
  Simple access to current user information
  """

  use Phoenix.HTML

  @doc """
  Returns an id of current user object
  """
  def current_user_id(conn) do
    conn.assigns.current_user.id
  end
end

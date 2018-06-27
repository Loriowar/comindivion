defmodule Comindivion.ViewHelper.CurrentUser do
  @moduledoc """
  Simple access to current user information
  """

  use Phoenix.HTML

  import Ecto.Query, only: [from: 2]

  @doc """
  Returns an id of current user object
  """
  def current_user_id(conn) do
    conn.assigns.current_user.id
  end

  @doc """
  Returns a query with filtration by current user
  """
  def current_user_query(conn, query) do
    from q in query, where: q.user_id == ^current_user_id(conn)
  end
end

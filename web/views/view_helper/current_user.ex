defmodule Comindivion.ViewHelper.CurrentUser do
  @moduledoc """
  Simple access to current user information
  """

  use Phoenix.HTML

  import Ecto.Query, only: [from: 2]

  @doc """
  Return a boolean: is a user logged in or not
  """
  def current_user_exist?(conn) do
    conn.assigns.current_user != nil
  end

  @doc """
  Returns a current user object
  """
  def current_user(conn) do
    conn.assigns.current_user
  end

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

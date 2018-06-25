defmodule Comindivion.ViewHelper.Url do
  @moduledoc """
  Conveniences for building url.
  """

  use Phoenix.HTML

  @doc """
  Generates url to previous page.
  """
  def back_path(conn) do
    NavigationHistory.last_path(conn, 1, default: "/")
  end
end

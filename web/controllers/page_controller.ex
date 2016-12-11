defmodule Comindivion.PageController do
  use Comindivion.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

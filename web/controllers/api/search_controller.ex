defmodule Comindivion.Api.SearchController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject

  import Ecto.Query, only: [where: 3, order_by: 3, limit: 2]

  def index(conn, %{"q" => search_string}) do
    mind_objects =
      conn
      |> current_user_query(MindObject)
      |> where([mo], ilike(mo.title, ^"%#{search_string}%") or ilike(mo.content, ^"%#{search_string}%"))
      |> order_by([mo], mo.title)
      |> limit(10)
      |> Repo.all

    render conn, "index.json", mind_objects: mind_objects
  end
end

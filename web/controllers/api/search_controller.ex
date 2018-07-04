defmodule Comindivion.Api.SearchController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject

  import Ecto.Query, only: [where: 3]

  def index(conn, %{"q" => search_string}) do
    mind_objects =
      conn
      |> current_user_query(MindObject)
      |> where([mo], ilike(mo.title, ^"%#{search_string}%") or ilike(mo.content, ^"%#{search_string}%"))
      |> Repo.all

    render conn, "index.json", mind_objects: mind_objects
  end
end

defmodule Comindivion.InteractiveController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject

  def index(conn, _params) do
    mind_object_changeset = MindObject.changeset(%MindObject{})
    render conn, "index.html", mind_object_changeset: mind_object_changeset
  end
end

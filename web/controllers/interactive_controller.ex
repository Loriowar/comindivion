defmodule Comindivion.InteractiveController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject
  alias Comindivion.SubjectObjectRelation
  alias Comindivion.Predicate

  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def fetch(conn, _params) do
    mind_objects = Repo.all(from m in MindObject, select: %{id: m.id, title: m.title})
    relations_query = from sor in SubjectObjectRelation,
                           join: p in Predicate, on: sor.predicate_id == p.id,
                           select: %{subject_id: sor.subject_id, object_id: sor.object_id, name: p.name}
    relations = Repo.all(relations_query)

    render conn, "fetch.json", mind_objects: mind_objects, relations: relations
  end
end

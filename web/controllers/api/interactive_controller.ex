defmodule Comindivion.Api.InteractiveController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject
  alias Comindivion.SubjectObjectRelation
  alias Comindivion.Predicate
  alias Comindivion.Position

  import Ecto.Query, only: [from: 2]

  def fetch(conn, _params) do
    mind_objects_query = from m in current_user_query(conn, MindObject),
                              left_join: p in Position, on: m.id == p.mind_object_id,
                              select: %{id: m.id, title: m.title, x: p.x, y: p.y}
    mind_objects = Repo.all(mind_objects_query)
    relations_query = from sor in SubjectObjectRelation,
                           join: p in Predicate, on: sor.predicate_id == p.id,
                           select: %{id: sor.id, subject_id: sor.subject_id, object_id: sor.object_id, name: p.name}
    relations = Repo.all(relations_query)

    render conn, "fetch.json", mind_objects: mind_objects, relations: relations
  end
end

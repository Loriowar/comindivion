defmodule Comindivion.Service.Interactive.NetworkInitializer do
  alias Comindivion.MindObject
  alias Comindivion.SubjectObjectRelation
  alias Comindivion.Predicate
  alias Comindivion.Position
  alias Comindivion.Repo

  import Ecto.Query, only: [from: 2]

  def call(%{current_user: current_user}) do
    current_user_id = current_user.id
    current_user_query_fn = fn(user_id, query) -> from q in query, where: q.user_id == ^user_id end
    mind_objects_query = from m in current_user_query_fn.(current_user_id, MindObject),
                              left_join: p in Position, on: m.id == p.mind_object_id,
                              select: %{id: m.id, title: m.title, x: p.x, y: p.y, group: p.group}
    mind_objects = Repo.all(mind_objects_query)
    relations_query = from sor in current_user_query_fn.(current_user_id, SubjectObjectRelation),
                           join: p in ^(current_user_query_fn.(current_user_id, Predicate)), on: sor.predicate_id == p.id,
                           select: %{id: sor.id, subject_id: sor.subject_id, object_id: sor.object_id, name: p.name}
    relations = Repo.all(relations_query)

    Comindivion.Serializer.Interactive.Network.json(%{mind_objects: mind_objects, relations: relations})
  end
end

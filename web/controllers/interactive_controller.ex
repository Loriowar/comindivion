defmodule Comindivion.InteractiveController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject
  alias Comindivion.SubjectObjectRelation
  alias Comindivion.Predicate

  def index(conn, _params) do
    mind_object_changeset = MindObject.changeset(%MindObject{})
    subject_object_relation_changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{})
    predicates_for_select =
      conn
      |> current_user_query(Predicate)
      |> select([p], {p.name, p.id})
      |> order_by([p], [asc: p.name])
      |> Repo.all
    is_predicates_blank = predicates_for_select == []
    render conn, "index.html", mind_object_changeset: mind_object_changeset,
                               subject_object_relation_changeset: subject_object_relation_changeset,
                               predicates_for_select: predicates_for_select,
                               is_predicates_blank: is_predicates_blank
  end
end

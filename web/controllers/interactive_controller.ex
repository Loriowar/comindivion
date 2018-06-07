defmodule Comindivion.InteractiveController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject
  alias Comindivion.SubjectObjectRelation
  alias Comindivion.Predicate

  def index(conn, _params) do
    mind_object_changeset = MindObject.changeset(%MindObject{})
    subject_object_relation_changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{})
    predicates_for_select = Repo.all(Predicate) |> Enum.map(&{&1.name, &1.id})
    render conn, "index.html", mind_object_changeset: mind_object_changeset,
                               subject_object_relation_changeset: subject_object_relation_changeset,
                               predicates_for_select: predicates_for_select
  end
end

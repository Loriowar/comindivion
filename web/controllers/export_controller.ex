defmodule Comindivion.ExportController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject
  alias Comindivion.SubjectObjectRelation
  alias Comindivion.Predicate

  import Ecto.Query, only: [from: 2]

  # TODO: looks similar to a api/interactive#index, maybe needs to extract base part to a separate module or simplify
  #       this using Poison
  def index(conn, _params) do
    mind_objects_query = from m in current_user_query(conn, MindObject),
                              left_join: p in assoc(m, :position),
                              select: %{
                                id: m.id,
                                title: m.title,
                                content: m.content,
                                uri: m.uri,
                                number: m.number,
                                date: m.date,
                                datetime: m.datetime,
                                group: p.group,
                                x: p.x,
                                y: p.y}
    mind_objects = Repo.all(mind_objects_query)
    relations_query = from sor in current_user_query(conn, SubjectObjectRelation),
                           join: p in ^current_user_query(conn, Predicate), on: sor.predicate_id == p.id,
                           select: %{
                             id: sor.id,
                             subject_id: sor.subject_id,
                             object_id: sor.object_id,
                             name: p.name}
    relations = Repo.all(relations_query)

    conn
    |> put_resp_content_type("application/json", "utf-8")
    |> put_resp_header("content-disposition", ~s[attachment; filename="comindivion_export.json"])
    |> render("index.json", mind_objects: mind_objects, relations: relations)
  end
end

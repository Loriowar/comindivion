defmodule Comindivion.SimilarityController do
  use Comindivion.Web, :controller

  alias Comindivion.MindObject

  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    # NOTE: usually, title is small, so we allow high similarity threshold
    mind_objects_similarity_by_title_query =
      from m in current_user_query(conn, MindObject),
           join: mm in ^current_user_query(conn, MindObject),
           on: m.id != mm.id and fragment("(? <-> ?) < ?", m.title, mm.title, 0.45),
           order_by: m.id,
           select: %{id: m.id, title: m.title, similar_id: mm.id, similar_title: mm.title}
    mind_objects_similarity_by_title = Repo.all(mind_objects_similarity_by_title_query)
    # NOTE: usually, content is large, so we allow small similarity threshold
    mind_objects_similarity_by_content_query =
      from m in current_user_query(conn, MindObject),
           join: mm in ^current_user_query(conn, MindObject),
           on: m.id != mm.id and fragment("(? <-> ?) < ?", m.content, mm.content, 0.25),
           order_by: m.id,
           select: %{id: m.id, title: m.title, similar_id: mm.id, similar_title: mm.title}
    mind_objects_similarity_by_content = Repo.all(mind_objects_similarity_by_content_query)
    render conn, "index.html", mind_objects_similarity_by_title: mind_objects_similarity_by_title,
                               mind_objects_similarity_by_content: mind_objects_similarity_by_content
  end
end

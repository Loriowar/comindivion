defmodule Comindivion.InteractiveView do
  use Comindivion.Web, :view

  def render("fetch.json", %{mind_objects: mind_objects, relations: relations}) do
    %{
      nodes: Enum.map(mind_objects, &mind_object_to_json/1),
      edges: Enum.map(relations, &relation_to_json/1)
    }
  end

  def mind_object_to_json(mind_object) do
    %{
      id: mind_object.id,
      label: mind_object.title
    }
  end

  def relation_to_json(relation) do
    %{
      from: relation.subject_id,
      to: relation.object_id,
      label: relation.name
    }
  end
end

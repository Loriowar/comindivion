defmodule Comindivion.Serializer.Interactive.Network do
  def json(%{mind_objects: mind_objects, relations: relations}) do
    %{
      nodes: Enum.map(mind_objects, &mind_object_to_json/1),
      edges: Enum.map(relations, &relation_to_json/1)
    }
  end

  defp mind_object_to_json(mind_object) do
    %{
      id: mind_object.id,
      label: mind_object.title,
      x: mind_object.x,
      y: mind_object.y,
      group: mind_object.group
    }
  end

  defp relation_to_json(relation) do
    %{
      id: relation.id,
      from: relation.subject_id,
      to: relation.object_id,
      label: relation.name
    }
  end
end

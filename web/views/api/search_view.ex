defmodule Comindivion.Api.SearchView do
  use Comindivion.Web, :view

  def render("index.json", %{mind_objects: mind_objects}) do
    %{
      nodes: Enum.map(mind_objects, &mind_object_to_json/1),
    }
  end

  def mind_object_to_json(mind_object) do
    %{
      id: mind_object.id,
      title: mind_object.title,
    }
  end
end

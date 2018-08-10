defmodule Comindivion.Api.InteractiveView do
  use Comindivion.Web, :view

  def render("index.json", %{mind_objects: mind_objects, relations: relations}) do
    Comindivion.Serializer.Interactive.Network.json(%{mind_objects: mind_objects, relations: relations})
  end
end

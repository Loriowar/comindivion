defmodule Comindivion.Api.MindObjectView do
  use Comindivion.Web, :view

  def render("show.json", params) do
    Comindivion.Serializer.Interactive.MindObject.json(params)
  end
end

defmodule Comindivion.Api.PositionView do
  use Comindivion.Web, :view

  def render("show.json", params) do
    Comindivion.Serializer.Interactive.Position.json(params)
  end
end

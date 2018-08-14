defmodule Comindivion.Api.SubjectObjectRelationView do
  use Comindivion.Web, :view

  def render("show.json", params) do
    Comindivion.Serializer.Interactive.SubjectObjectRelation.json(params)
  end
end

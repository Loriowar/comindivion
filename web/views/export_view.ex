defmodule Comindivion.ExportView do
  use Comindivion.Web, :view

  def render("index.json", %{mind_objects: mind_objects, relations: relations}) do
    %{
      mind_objects: mind_objects,
      relations: relations
    }
  end
end

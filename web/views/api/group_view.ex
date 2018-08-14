defmodule Comindivion.Api.GroupView do
  use Comindivion.Web, :view

  def render("show.json", %{positions: positions}) do
    Comindivion.Serializer.Interactive.Position.json(%{positions: positions})
  end

  def render("show.json", %{groups: groups}) do
    %{
      groups: groups
    }
  end
end

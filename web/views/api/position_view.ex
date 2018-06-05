defmodule Comindivion.Api.PositionView do
  use Comindivion.Web, :view

  def render("show.json", %{position: position}) do
    %{
      position: position
    }
  end
end

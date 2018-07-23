defmodule Comindivion.Api.GroupView do
  use Comindivion.Web, :view

  def render("show.json", %{positions: positions}) do
    Enum.map(positions,
      fn(position) ->
        %{
          position: position
        }
      end
    )
  end
end

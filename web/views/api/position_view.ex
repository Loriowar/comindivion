defmodule Comindivion.Api.PositionView do
  use Comindivion.Web, :view

  def render("show.json", %{position: position}) do
    %{
      position: position
    }
  end

  def render("show.json", %{positions: positions}) do
    Enum.map(positions,
      fn(position) ->
        %{
          position: position
        }
      end
    )
  end

  def render("show.json", %{changeset: changeset}) do
    %{
      position: %{
        errors: changeset_to_message(changeset)
      }
    }
  end

  # TODO: move to a separate module due to usage in multiple api views
  def changeset_to_message(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end

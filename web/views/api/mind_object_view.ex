defmodule Comindivion.Api.MindObjectView do
  use Comindivion.Web, :view

  def render("show.json", %{mind_object: mind_object}) do
    %{
      mind_object: mind_object
    }
  end

  def render("show.json", %{mind_objects: mind_objects}) do
    Enum.map(mind_objects,
      fn(mind_object) ->
        %{
          mind_object: mind_object
        }
      end
    )
  end

  def render("show.json", %{changeset: changeset}) do
    %{
      mind_object: %{
        errors: changeset_to_message(changeset)
      }
    }
  end

  # TODO: move to a separate module due to usage in a multiple api views
  def changeset_to_message(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end

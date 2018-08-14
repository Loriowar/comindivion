defmodule Comindivion.Serializer.Interactive.MindObject do
  def json(%{mind_object: mind_object}) do
    %{
      mind_object: mind_object
    }
  end

  def json(%{mind_objects: mind_objects}) do
    %{mind_objects:
      Enum.map(mind_objects,
        fn(mind_object) ->
          %{
            mind_object: mind_object
          }
        end
      )
    }
  end

  def json(%{changeset: changeset}) do
    %{
      mind_object: %{
        errors: changeset_to_message(changeset)
      }
    }
  end

  # TODO: move to a separate module due to usage in a multiple api views
  defp changeset_to_message(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end

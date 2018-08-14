defmodule Comindivion.Serializer.Interactive.Position do
  def json(%{position: position}) do
    %{
      position: position
    }
  end

  def json(%{positions: positions}) do
    %{positions:
      Enum.map(positions,
        fn(position) ->
          %{
            position: position
          }
        end
      )
    }
  end

  def json(%{changeset: changeset}) do
    %{
      position: %{
        errors: changeset_to_message(changeset)
      }
    }
  end

  # TODO: move to a separate module due to usage in multiple api views
  defp changeset_to_message(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end

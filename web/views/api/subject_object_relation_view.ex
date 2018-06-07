defmodule Comindivion.Api.SubjectObjectRelationView do
  use Comindivion.Web, :view

  def render("show.json", %{subject_object_relation: subject_object_relation}) do
    %{
      subject_object_relation: %{
        id: subject_object_relation.id,
        subject_id: subject_object_relation.subject_id,
        object_id: subject_object_relation.object_id,
        predicate_id: subject_object_relation.predicate_id,
        name: subject_object_relation.predicate.name
      }
    }
  end

  def render("show.json", %{changeset: changeset}) do
    %{
      subject_object_relation: %{
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

defmodule Comindivion.Service.Converter.DiffToDbFormat do
  # Return a hash prepared for store in a history record:
  # %{
  #   model_name => %{
  #     pk => %{
  #       action: create/update/delete,
  #       changes: %{
  #         column_name_1 => %{
  #           old: previous_value,
  #           new: new_value
  #         },
  #         column_name_2 => ...
  #       }
  #     }
  #   }
  # }
  def call(diff: diff, model_name: model_name) do
    %{
      model_name =>
        diff
        |> Enum.reduce(
             %{},
             fn({id, change}, acc) ->
               acc
               |> Map.put(id, %{changes: change, action: :update})
             end
           )
    }
  end
end

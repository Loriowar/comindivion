defmodule Comindivion.Service.History.Diff.Generate do
  alias Comindivion.Repo

  import Ecto.Query, only: [select: 3, where: 3]

  # Return a diff with follows structure:
  # %{
  #   column_name: %{
  #     old: old_value,
  #     new: new_value
  #   },
  #   ...
  # }
  # TODO: split on two services: first is 'pure' and generate diff from changesets and records,
  #       second - 'dirty' and fetch required records for the first one
  def call(changesets: changesets, query: query, primary_key: primary_key) do
    changed_column_names = (changesets |> hd).changes |> Map.keys
    select_structure = [primary_key | changed_column_names]
    ids = changesets |> Enum.map(&(&1.data |> Map.get(primary_key)))
    old_records_data =
      query
      |> where([q], field(q, ^primary_key) in ^ids)
      |> select([q], map(q, ^select_structure))
      |> Repo.all
      |> Enum.reduce(
           %{},
           fn(old_record, acc) ->
             acc
             |> Map.put(
                  old_record[primary_key],
                  Map.take(old_record, changed_column_names)
                )
           end
         )

    new_records_data =
      changesets
      |> Enum.reduce(
           %{},
           fn(changeset, acc) ->
             acc
             |> Map.put(
                  changeset.data |> Map.get(primary_key),
                  changeset.changes
                )
           end
         )

    new_records_data
    |> Enum.reduce(
         %{},
         fn({id, data}, acc) ->
           history_data =
             data
             |> Enum.reduce(
                  %{},
                  fn({column_name, value}, iacc) ->
                    iacc
                    |> Map.put(
                         column_name,
                         %{
                           old: value,
                           new: old_records_data[id][column_name]
                         }
                       )
                  end
                )
           acc |> Map.put(id, history_data)
         end
       )
  end
end

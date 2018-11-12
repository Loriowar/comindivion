defmodule Comindivion.Context.Position.BulkUpdate do
  alias Comindivion.{Position, History, Repo}
  import Comindivion.Context.History.Mixin.HistoryForUser

  # Expected structure of input data:
  # { position_params:
  #   { mind_object1_uuid:
  #     { x: value,
  #       y: value
  #     },
  #     mind_object2_uuid: {...},
  #     ...
  #   }
  # }
  # TODO: single transaction for read and write operations for data consistency
  def execute(positions_params: positions_params, user: user) do
    position_changesets =
      Enum.map(positions_params,
        fn({mind_object_id, position_data}) ->
          Position.changeset(
            %Position{mind_object_id: mind_object_id},
            position_data
          )
        end
      )

    operations =
      Ecto.Multi.new()
      |> Ecto.Multi.run(
           :history,
           fn(_) ->
             diff = Comindivion.Service.History.Diff.Generate.call(changesets: position_changesets, query: Position, primary_key: :mind_object_id)
             history_content = Comindivion.Service.Converter.DiffToDbFormat.call(diff: diff, model_name: (position_changesets |> hd).data.__struct__)
             new_history =
               History.changeset(%History{user_id: user.id, previous_history_id: current_history_id(user)}, %{diff: history_content})
               |> Repo.insert!
             Ecto.Changeset.change(user, current_history_id: new_history.id)
             |> Repo.update
           end
         )

    result =
      position_changesets
      |> Enum.reduce(
           operations,
           fn(changeset, multi) ->
             Ecto.Multi.insert(
               multi,
               changeset.data.mind_object_id,
               changeset,
               on_conflict: :replace_all,
               conflict_target: :mind_object_id)
           end
         )
      |> Repo.transaction

    case result do
      {:ok, positions } ->
        {
          :ok,
          positions |> Enum.reject(fn({id, _}) -> id == :history end) |> Enum.into(%{}),
          positions[:history]}
      {:error, failed_operation, failed_value, _ } ->
        case failed_operation do
          :history ->
            {:error, failed_operation}
          _ ->
            {:error, failed_value}
        end
    end
  end
end

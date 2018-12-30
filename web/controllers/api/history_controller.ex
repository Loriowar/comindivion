defmodule Comindivion.Api.HistoryController do
  use Comindivion.Web, :controller

  alias Comindivion.{Position, History, Repo}

  import Comindivion.Context.History.Mixin.HistoryForUser

  def undo(conn, _params) do
    previous_history = (conn |> current_user |> previous_history).diff
    if previous_history do
      rollback_model_names = Map.keys(previous_history)
#      rollback_models = rollback_model_names |> Enum.map(&("Elixir.#{&1}")) |> Enum.map(&String.to_existing_atom/1)
      Enum.each(
        rollback_model_names,
        fn(model_name) ->
          case model_name do
            "Elixir.Comindivion.Position" ->
              positions_data = previous_history[model_name]
              Enum.each(
                positions_data,
                fn({uuid, data}) ->
                  # TODO: for now, atoms before save transformed to strings after fetch from db, needs try to fix this
                  changes = data["changes"]
                  action_type = data["action"]
                  case action_type do
                    "update" ->
                      target_model = String.to_existing_atom(model_name)
                      # TODO: needs a mapping of model name and primary key, stored in history data
                      primary_key_name = :mind_object_id
                      model_data = for {column_name, change} <- changes, into: %{} do {column_name, change["old"]} end
                      changeset = target_model.changeset(
                        struct(target_model, %{primary_key_name => uuid}),
                        model_data
                      )
#                      require IEx; IEx.pry
                  end
                end
              )
          end
        end
      )
    else
      # TODO: move to view method `render_nothing`
      conn
      |> put_status(200)
      |> text("No previous history found")
    end

    #TODO: render error if `previous_history` is nil
#    previous_history.diff |> Enum(fn())
#    position_params = previous_history.diff |> Enum.map(%{}, fn)
  end

  def redo(conn, _params) do
    # TODO: process end of redo; send 200 if all ok and push a changes to socket
  end
end

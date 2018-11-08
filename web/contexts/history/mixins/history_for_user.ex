defmodule Comindivion.Context.History.Mixin.HistoryForUser do
  alias Comindivion.{History, Repo}

  import Ecto.Query, only: [from: 2, select: 3]

  @doc """
  Returns a query for a last history
  """
  def last_history_query(user_id) do
    from(
      h in History,
      where: h.user_id == ^user_id,
      order_by: [desc: h.inserted_at],
      limit: 1
    )
  end

  @doc """
  Returns a last history record for user
  """
  def last_history(user_id) do
    last_history_query(user_id)
    |> Repo.one
  end

  @doc """
  Returns an id of a last history record
  """
  def last_history_id(user_id) do
    last_history_query(user_id)
    |> select([h], h.id)
    |> Repo.one
  end
end

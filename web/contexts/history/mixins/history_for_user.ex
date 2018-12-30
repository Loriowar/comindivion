defmodule Comindivion.Context.History.Mixin.HistoryForUser do
  alias Comindivion.{History, Repo}

  import Ecto.Query, only: [from: 2]

  @doc """
  Returns a last history record for user
  """
  def current_history(user) do
    (user |> Repo.preload(:current_history)).current_history
  end

  @doc """
  Returns an id of a last history record
  """
  def current_history_id(user) do
    user.current_history_id
  end

  @doc """
  Returns an id of a previous history record
  """
  def previous_history_id(user) do
    current_history(user).previous_history_id
  end

  @doc """
  Returns a previous history record for user
  """
  def previous_history(user) do
    from(h in History,
         where: h.id == ^current_history_id(user),
         join: ph in History,
         on: h.previous_history_id == ph.id,
         select: [ph])
    |> Repo.one
    |> hd
  end
end

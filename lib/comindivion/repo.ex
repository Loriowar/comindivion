defmodule Comindivion.Repo do
  use Ecto.Repo, otp_app: :comindivion

  import Ecto.Query, only: [from: 2]

  def exists?(queryable) do
    query = from x in queryable, select: 1, limit: 1
    case all(query) do
      [1] -> true
      [] -> false
    end
  end
end

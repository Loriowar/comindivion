defmodule Comindivion.Auth.Constant do
  @salt "current_user_token"
  def salt, do: @salt

  @max_age 24 * 60 * 60
  def max_age, do: @max_age
end

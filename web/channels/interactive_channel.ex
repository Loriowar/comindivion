defmodule Comindivion.InteractiveChannel do
  use Phoenix.Channel

  def join("interactive:" <> user_id, _params, socket) do
    {:ok, socket}
  end
end
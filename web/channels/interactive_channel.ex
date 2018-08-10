defmodule Comindivion.InteractiveChannel do
  use Phoenix.Channel

  def join("interactive:" <> user_id, _params, socket) do
    if user_id == socket.assigns.current_user.id do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    network_data = Comindivion.Service.Interactive.NetworkInitializer.call(%{current_user: socket.assigns.current_user})
    push(socket, "interactive:network:initialize", network_data)
    {:noreply, socket} # :noreply
  end
end

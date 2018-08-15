defmodule Comindivion.InteractiveChannel do
  use Phoenix.Channel

  def join("interactive:" <> user_id, _params, socket) do
    if user_id == socket.assigns.current_user.id do
      # Now we use REST-API for the network initialization
      # send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Works together with message processing from 'web/static/js/interactive_channel.js'
  def handle_info(:after_join, socket) do
    network_data =
      Comindivion.Service.Interactive.NetworkInitializeData.call(%{current_user: socket.assigns.current_user})
      |> Comindivion.Serializer.Interactive.Network.json
    push(socket, "interactive:network:initialize", network_data)
    {:noreply, socket} # :noreply
  end
end

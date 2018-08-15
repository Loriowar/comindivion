defmodule Comindivion.Api.InteractiveController do
  use Comindivion.Web, :controller

  def index(conn, _params) do
    network_data = Comindivion.Service.Interactive.NetworkInitializeData.call(%{current_user: current_user(conn)})

    render conn, "index.json", network_data
  end
end

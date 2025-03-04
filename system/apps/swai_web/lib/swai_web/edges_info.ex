defmodule SwaiWeb.EdgesInfo do
  use SwaiWeb, :verified_routes

  @moduledoc """
  The EdgesInfo is intended to mount edges information
  """

  require Logger

def on_mount(:mount_edges_count, _params, session, socket) do
  {:cont, mount_edges_count(socket, session)}
end


defp mount_edges_count(socket, _session) do
  Logger.info("mount_edges_count")
  Phoenix.Component.assign_new(socket, :edges_count, fn ->
    Edges.Service.count()
  end)
end



end

defmodule Ring.Router do
  use Plug.Router

  plug(Plug.Static, at: "/", from: :ring)
  plug(:match)
  plug(:dispatch)

  get "/ring" do
    WebSockAdapter.upgrade(conn, SwaiWeb.RingHandler, %{}, [])
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end

defmodule SwaiWeb.RingsController do
  @moduledoc false
  use SwaiWeb, :controller

  alias Rings.Service, as: RingS

  def register_offer(conn, %{"scape_id" => scape_id, "offer" => offer}) do
    RingS.register_offer(scape_id, offer)
    send_resp(conn, 200, offer)
  end

  def get_ring_offer(conn, %{"scape_id" => scape_id}) do
    case RingS.get_offer(scape_id) do
      nil ->
        send_resp(conn, 404, "Offer not found")
      offer ->
        json = Jason.encode!(offer)
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, json)
    end
  end  
  
end

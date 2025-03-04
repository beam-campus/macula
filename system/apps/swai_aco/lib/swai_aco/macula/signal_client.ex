defmodule Macula.SignalClient do
  @moduledoc false
  require Logger  
  require Req

  def get_ring_offer(scape_id) do
    url = Application.get_env(:swai_edge, Macula.SignalClient)[:rings_url]
    response = Req.get!("#{url}/#{scape_id}")
    case response.status do
      200 ->
        {:ok, response.body}
      404 ->
        {:ok, nil}
      status_code ->
        Logger.error("#{__MODULE__} failed to get ring offer, status_code: #{status_code}")
        {:ok, nil}
    end
  end

  def register_ring_offer(scape_id, offer) do
    url = Application.get_env(:swai_edge, Macula.SignalClient)[:rings_url]
    body = %{
      "scape_id" => scape_id,
      "offer" => offer
    }
    response = Req.post!("#{url}", json: body)
    case response.status do
      200 ->
        {:ok, response.body}
      status_code ->
        Logger.error("#{__MODULE__} failed to register ring offer, status_code: #{status_code}")
        {:error, response.body}
    end
  end
  
  
end

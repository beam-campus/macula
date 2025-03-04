defmodule SwaiWeb.RemoteImageController do
  use SwaiWeb, :controller

  alias Swai.Biotopes, as: Biotopes
  alias Schema.Biotope, as: Biotope

  require Logger

  import Plug.Conn

  def image_url(conn, %{"id" => id}) do
    case Biotopes.get_biotope!(id) do
      nil ->
        send_resp(conn, 404, "Biotope not found")

      %Biotope{image_url: nil} ->
        send_resp(conn, 404, "Image URL not found for the specified biotope")

      %Biotope{image_url: image_url} ->
        stream_image(conn, image_url)
    end
  end

  defp stream_image(conn, image_url) do
    case HTTPoison.get!(image_url, [], stream_to: self()) do
      %HTTPoison.AsyncResponse{id: id} ->
        conn
        # Adjust the content type based on actual image type
        |> put_resp_content_type("image/jpeg")
        |> send_chunked(200)
        |> stream_body(id)

      # %HTTPoison.Error{reason: reason} ->
      #   Logger.error("Failed to fetch image: #{reason}")
      #   send_resp(conn, 500, "Internal server error")

      _ ->
        send_resp(conn, 500, "Internal server error")
    end
  end

  defp stream_body(conn, id) do
    receive do
      %HTTPoison.AsyncStatus{} ->
        stream_body(conn, id)

      %HTTPoison.AsyncHeaders{} ->
        stream_body(conn, id)

      %HTTPoison.AsyncChunk{chunk: chunk} ->
        case chunk(conn, chunk) do
          {:ok, conn} -> stream_body(conn, id)
          {:error, %Plug.Conn{} = conn} -> stream_body(conn, id)
        end

      %HTTPoison.AsyncEnd{} ->
        conn
    end
  end
end

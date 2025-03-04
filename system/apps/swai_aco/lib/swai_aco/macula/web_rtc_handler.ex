defmodule Macula.WebRtcHandler do
  @moduledoc """
  Macula WebRtcHandler is the WebRTC scape component that establishes a WebRTC ring connection with users' browsers.
  It is responsible for streaming events to the browsers, for the purpose of visualizing scape data.
  """
  alias ExWebRTC.DataChannel, as: RingDataChannel
  alias ExWebRTC.ICECandidate, as: ICECandidate

  require Logger

  def handle_webrtc_msg({:connection_state_change, :new}, state) do
    Logger.info("New Macula Ring has been established")
    {:noreply, state}
  end

  def handle_webrtc_msg({:signaling_state_change, :stable}, state) do
    Logger.info("Ring Connection is stable")
    {:noreply, state}
  end

  # def handle_webrtc_msg({:ice_candidate, candidate}, state) do
  #   candidate_json = ICECandidate.to_json(candidate)
  #
  #   msg =
  #     %{"type" => "ice", "data" => candidate_json}
  #     |> Jason.encode!()
  #
  #   Logger.info("Sent ICE candidate: #{candidate_json["candidate"]}")
  #
  #   {:push, {:text, msg}, state}
  # end

  # def handle_webrtc_msg({:data_channel, %RingDataChannel{ref: ref}}, state) do
  #   state = %{state | data_channel_ref: ref}
  #   {:ok, state}
  # end

  # def handle_webrtc_msg({:data, ref, data}, %{data_channel_ref: ref} = state) do
  #   Registry.dispatch(Swai.PubSub, "chat", fn entries ->
  #     for {pid, _} <- entries, do: send(pid, {:chat_msg, data})
  #   end)
  #
  #   {:ok, state}
  # end

  def handle_webrtc_msg(
        {:data_channel_state_change, ref, :closed},
        %{data_channel_ref: ref} = state
      ) do
    Logger.info("Channel #{inspect(ref)} has been closed")
    {:stop, {:shutdown, :channel_closed}, state}
  end

  def handle_webrtc_msg(_msg, state), do: {:noreply, state}
end

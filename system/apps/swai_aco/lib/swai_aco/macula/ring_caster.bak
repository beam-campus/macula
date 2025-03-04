defmodule Macula.Ringcaster do
  @moduledoc """
  Madcula Ringcaster is the WebRTC scape component that establishes a WebRTC ring connection with users' browsers.
  It is responsible for streaming events to the browsers, for the purose of visualizing scape data.
  """
  use GenServer

  alias Swai.Registry, as: EdgeRegistry
  alias Colors, as: Colors
  alias Phoenix.PubSub, as: PubSub
  alias Particle.Facts, as: ParticleFacts

  alias ExWebRTC.PeerConnection, as: RingPeer
  # alias ExWebRTC.DataChannel, as: RingDataChannel
  # alias ExWebRTC.SessionDescription, as: RingSessionDescription
  # alias ExWebRTC.IceCandidate, as: RingIceCandidate

  alias Macula.WebRtcHandler, as: WebRtcHandler
  alias Macula.SignalClient, as: SignalClient

  require Logger

  @ice_servers [
    %{urls: "stun:stun.l.google.com:19302"}
  ]

  @particle_facts ParticleFacts.particle_facts()
  @particle_moved_v1 {:particle, ParticleFacts.particle_moved_v1()}

  def start(%{scape_id: scape_id} = scape_init) do
    case start_link(scape_init) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error(
          "#{__MODULE__}:#{scape_id} failed to start, reason: #{inspect(reason, pretty: true)}"
        )
        {:error, reason}
    end
  end

  ############### SUBSCRIPTIONS #########################
  @impl true
  def handle_info({:ex_webrtc, _from, msg}, state) do
    WebRtcHandler.handle_webrtc_msg(msg, state)
  end

  @impl true
  def handle_info({:particle, msg}, %{ring: ring, data_channel_ref: data_channel} = state) do
       Logger.alert("Incoming particle message: #{inspect(msg)}")
       case ring
       |> RingPeer.send_data(data_channel, msg) do
         {:ok, _} ->
           {:noreply, state}

         {:error, reason} ->
           Logger.error("#{__MODULE__} failed to send data to ring, reason: #{inspect(reason)}")
           {:stop, {:shutdown, :send_data_failed}, state}
       end
  end

  @impl true
  def handle_info({:EXIT, pc, reason}, %{peer_connection: pc} = state) do
    Logger.info("#{__MODULE__} exited, reason: #{inspect(reason)}")
    {:stop, {:shutdown, :pc_closed}, state}
  end

  @impl true
  def handle_info(_, state) do
    {:noreply, state}
  end

  ################## TERMINATE #######################
  @impl true
  def terminate(reason, _state) do
    Logger.alert("WebSocket connection was terminated, reason: #{inspect(reason)}")
  end

  defp do_start_ring_connection() do
    case RingPeer.start_link(ice_servers: @ice_servers) do
      {:ok, rc} ->
        rc

      {:error, reason} ->
        Logger.warning(
          "#{__MODULE__} failed to start ring connection, reason: #{inspect(reason, pretty: true)}"
        )

        nil
    end
  end

  defp do_create_data_channel(rc, scape_id) do
    case RingPeer.create_data_channel(rc, scape_id) do
      {:ok, dc} ->
        dc

      {:error, reason} ->
        Logger.error("#{__MODULE__} failed to create data channel, reason: #{inspect(reason, pretty: true)}")
        nil
    end
  end

  defp do_create_offer(rc) do
    case RingPeer.create_offer(rc) do
      {:ok, offer} ->
        offer

      {:error, reason} ->
        Logger.error("#{__MODULE__} failed to create offer, reason: #{inspect(reason, pretty: true)}")
        nil
      end
  end

  defp do_register_offer(scape_id, offer) do
    case SignalClient.register_ring_offer(scape_id, offer) do
      {:ok, offer} ->
        {:ok, offer}
      {:error, reason} ->
        Logger.error("#{__MODULE__} failed to register offer, reason: #{inspect(reason, pretty: true)}")
    end
  end



  ##################### INIT ############################
  @impl true
  def init(%{scape_id: scape_id} = scape_init) do
   rc = do_start_ring_connection()
   dc = do_create_data_channel(rc, scape_id)
   web_rtc = do_create_offer(rc)
   RingPeer.set_local_description(rc, web_rtc)
   if  %{type: type, sdp: sdp} = web_rtc do
      reg_offer = Task.async(fn -> do_register_offer(scape_id, %{type: type, sdp: sdp}) end)

      state = %{
       scape: scape_init,
       ring: rc,
       data_channel_ref: dc
      }

      :edge_pubsub
      |> PubSub.subscribe(@particle_facts)

      Logger.debug("#{__MODULE__} for [#{scape_id}] is UP => #{Colors.scape_theme(self())}")
      Task.await(reg_offer)
      {:ok, state}
    else
      {:stop, {:shutdown, :create_offer_failed}, %{scape: scape_init}}
    end
  end

  @impl true
  def handle_continue(continue_arg, state) do
    Logger.warning("Continuing with: #{inspect(continue_arg)}")
   {:ok, state} 
  end

  ###################### PLUMBING ########################
  def to_name(key),
    do: "#{__MODULE__}:#{key}"

  def via(key),
    do: EdgeRegistry.via_tuple({:macula_ring_caster, to_name(key)})

  def child_spec(%{scape_id: scape_id} = scape_init),
    do: %{
      id: to_name(scape_id),
      start: {__MODULE__, :start, [scape_init]},
      type: :worker,
      restart: :transient
    }

  def start_link(%{scape_id: scape_id} = scape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        scape_init,
        name: via(scape_id)
      )
end

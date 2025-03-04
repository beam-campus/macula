defmodule SwaiWeb.EdgeChannel do
  use SwaiWeb, :channel

  @moduledoc """
  The EdgeChannel is used to broadcast messages to all clients
  """
  require Logger
  require Phoenix.PubSub

  alias SwaiWeb.ArenaDispatcher, as: ArenaDispatcher
  alias SwaiWeb.Dispatch.ChannelWatcher
  alias SwaiWeb.EdgeDispatcher, as: EdgeDispatcher
  alias SwaiWeb.EdgePresence, as: EdgePresence
  alias SwaiWeb.HiveDispatcher, as: HiveDispatcher
  alias SwaiWeb.ScapeDispatcher, as: ScapeDispatcher
  alias SwaiWeb.ParticleDispatcher, as: ParticleDispatcher

  alias Edge.Facts, as: EdgeFacts

  alias Arena.Facts, as: ArenaFacts
  alias Hive.Facts, as: HiveFacts
  alias Hive.Hopes, as: HiveHopes
  alias Scape.Facts, as: ScapeFacts
  alias Particle.Facts, as: ParticleFacts

  @hope_shout "hope:shout"
  @hope_ping "ping"
  @hope_join_edge "join_edge"

  @edge_attached_v1 EdgeFacts.edge_attached_v1()

  # @scape_attached_v1 ScapeFacts.scape_attached_v1()
  @scape_detached_v1 ScapeFacts.scape_detached_v1()
  @scape_initializing_v1 ScapeFacts.scape_initializing_v1()
  @scape_initialized_v1 ScapeFacts.scape_initialized_v1()

  @hive_detached_v1 HiveFacts.hive_detached_v1()
  @hive_initialized_v1 HiveFacts.hive_initialized_v1()
  @hive_occupied_v1 HiveFacts.hive_occupied_v1()
  @hive_vacated_v1 HiveFacts.hive_vacated_v1()

  @arena_initialized_v1 ArenaFacts.arena_initialized_v1()

  @particle_spawned_v1 ParticleFacts.particle_spawned_v1()
  @particle_changed_v1 ParticleFacts.particle_changed_v1()
  @particle_died_v1 ParticleFacts.particle_died_v1()

  @presence_changed_v1 EdgeFacts.presence_changed_v1()
  @edge_lobby "edge:lobby"
  @reserve_license_v1 HiveHopes.reserve_license_v1()

  ################ CALLBACKS ################
  @impl true
  def join(@edge_lobby, edge_init, socket) do
    send(self(), {:after_join, edge_init})

    ChannelWatcher.monitor(
      @edge_lobby,
      self(),
      {EdgeDispatcher, :pub_edge_detached, [%{"edge_init" => edge_init}]}
    )

    {:ok, socket}
  end

  ####################### AFTER JOIN #######################
  @impl true
  def handle_info({:after_join, %{"edge_id" => edge_id}}, socket) do
    Logger.info(":after_join #{inspect(socket)}")

    {:ok, _} =
      socket
      |> EdgePresence.track(edge_id, %{
        online_at: inspect(System.system_time(:second))
      })

    socket
    |> broadcast(@presence_changed_v1, EdgePresence.list(socket))

    {:noreply, socket}
  end

  ########################## IN HELLO ############################
  @impl true
  def handle_in("hello", payload, socket) do
    socket
    |> broadcast!("hello", payload)

    {:reply, {:ok, payload}, socket}
  end

  ############################# IN PING ############################
  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(@hope_ping, payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  ########################## IN JOIN EDGE ############################
  @impl true
  def handle_in(@hope_join_edge, payload, socket) do
    socket
    |> broadcast!(@hope_join_edge, payload)

    {:noreply, socket}
  end

  ############################# IN SHOUT ############################
  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (farm:lobby).
  @impl true
  def handle_in(@hope_shout, payload, socket) do
    socket
    |> broadcast!(@hope_shout, payload)

    {:noreply, socket}
  end

  #################### IN EDGE ATTACHED ###########################
  @impl true
  def handle_in(@edge_attached_v1, payload, socket) do
    EdgeDispatcher.pub_edge_attached(payload, socket)
    {:noreply, socket}
  end

  #################### IN EDGE DETACHED ###########################
  ## Edge Detached is handled by the ChannelWatcher (see join/3) ##
  ################################################################

  ################### IN INITIALIZING SCAPE #######################
  @impl true
  def handle_in(@scape_initializing_v1, payload, socket) do
    ScapeDispatcher.pub_scape_initializing(payload)
    {:noreply, socket}
  end

  ##################### IN SCAPE INITIALIZED #######################
  @impl true
  def handle_in(@scape_initialized_v1, payload, socket) do
    ScapeDispatcher.pub_scape_initialized(payload)
    {:noreply, socket}
  end

  ##################### IN SCAPE DETACHED ##########################
  @impl true
  def handle_in(@scape_detached_v1, payload, socket) do
    ScapeDispatcher.pub_scape_detached(payload)
    {:noreply, socket}
  end

  ##################### IN HIVE INITIALIZED ########################
  @impl true
  def handle_in(@hive_initialized_v1, payload, socket) do
    HiveDispatcher.pub_hive_initialized(payload)
    {:noreply, socket}
  end

  #################### IN HIVE OCCUPIED ###########################
  @impl true
  def handle_in(@hive_occupied_v1, payload, socket) do
    HiveDispatcher.pub_hive_occupied(payload)
    {:noreply, socket}
  end

  ################### HIVE VACATED ###############################
  @impl true
  def handle_in(@hive_vacated_v1, payload, socket) do
    HiveDispatcher.pub_hive_vacated(payload)
    {:noreply, socket}
  end

  ################### HIVE DETACHED ##############################
  @impl true
  def handle_in(@hive_detached_v1, payload, socket) do
    HiveDispatcher.pub_hive_detached(payload)
    {:noreply, socket}
  end

  ########## IN HIVE ARENA INITIALIZED ##########################
  @impl true
  def handle_in(@arena_initialized_v1, payload, socket) do
    ArenaDispatcher.pub_arena_initialized(payload)
    {:noreply, socket}
  end

  ############## IN RESERVE LICENSE ##########################
  @impl true
  def handle_in(@reserve_license_v1, payload, socket) do
    reply = HiveDispatcher.try_reserve_license(payload)
    {:reply, {:ok, reply}, socket}
  end

  ############# IN PARTICLE SPAWNED ########################
  @impl true
  def handle_in(@particle_spawned_v1, envelope, socket) do
    ParticleDispatcher.pub_particle_spawned(envelope)
    {:noreply, socket}
  end

  ############# IN PARTICLE CHANGED ########################
  @impl true
  def handle_in(@particle_changed_v1, envelope, socket) do
    ParticleDispatcher.pub_particle_changed(envelope)
    {:noreply, socket}
  end
  
  ############# IN PARTICLE DIED ########################
  @impl true
  def handle_in(@particle_died_v1, envelope, socket) do
    ParticleDispatcher.pub_particle_died(envelope)
    {:noreply, socket}
  end
  
  

  ##################### CHANNEL FALLTHROUGH ######################
  @impl true
  def handle_in(msg, payload, socket) do
    Logger.info("
      Unhandled Message: 
      [#{msg}] 

      Payload:
      #{inspect(payload)}")
    {:noreply, socket}
  end

 



  ##################### TERMINATE ##############################
  @impl true
  def terminate(reason, socket) do
    Logger.info("Terminating EdgeChannel: #{inspect(reason)}")
    {:ok, socket}
  end
  
end

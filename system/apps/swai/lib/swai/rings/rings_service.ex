defmodule Rings.Service do
  @moduledoc false
  
  
  use GenServer 

  require Logger
  require Colors


  alias Scape.Facts, as: ScapeFacts
  alias Scape.Init, as: Scape
  alias Phoenix.PubSub, as: PubSub

  @scape_facts ScapeFacts.scape_facts()
  @scape_detached_v1 ScapeFacts.scape_detached_v1()


  def register_offer(scape_id, offer) do
    GenServer.cast(
      __MODULE__, 
      {:register_offer, scape_id, offer}
    )
  end


  def get_offer(scape_id) do
    GenServer.call(
      __MODULE__,
      {:get_offer, scape_id}
    )
  end

  def get_all do
    GenServer.call(
      __MODULE__,
      :get_all
    )
  end
  

  @impl true
  def handle_cast({:register_offer, scape_id, offer}, state) do
    :rings_cache
    |> Cachex.put!(scape_id, offer)
    
    {:noreply, state}
  end

  
  @impl true
  def handle_call(:get_all, _from, state) do
    offers =
      :rings_cache
      |> Cachex.stream!()
      |> Stream.map(fn {:entry, ring_id, _internal_key, _nil, offer} -> %{ring_id: ring_id, offer: offer} end)
      |> Enum.to_list()

    {:reply, offers, state}
  end
  

  @impl true
  def handle_call({:get_offer, scape_id}, _from, state) do
    offer =
      :rings_cache
      |> Cachex.get!(scape_id)

    {:reply, offer, state}
  end

  ################# START #####################
  def start(opts) do
    case start_link(opts) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, reason} ->
        Logger.error("Failed to start #{__MODULE__}: #{inspect(reason, pretty: true)}")
        {:error, reason}
    end
  end
  

  ############### INIT ###########
  @impl true
  def init(init_args) do
    Logger.info("Rings Service is UP => #{Colors.scape_theme(self())}")

    Swai.PubSub
    |> PubSub.subscribe(@scape_facts)

    {:ok, init_args} 
  end
  

  ####################### SCAPE DETACHED ########################
  @impl true
  def handle_info(
        {@scape_detached_v1, %Scape{scape_id: scape_id}},
        state
      ) do
    Logger.alert("Scape Detached, deleting offers for #{scape_id}")

    :rings_cache
    |> Cachex.del!(scape_id)

    {:noreply, state}
  end

  ########################### FALLTHROUGHS #########################
  ## Handle Info Fallthrough
  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end



  ########### PLUMBING ############
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start, [opts]},
      type: :worker,
      restart: :transient
    }
  end

  def start_link(opts) do
    GenServer.start_link(
      __MODULE__,
      opts,
      name: __MODULE__
    )
  end
  


  
end


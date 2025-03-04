defmodule Licenses.Db do
  @moduledoc """
  The service wrapper module for the swarm trainings cache.
  """
  use GenServer

  alias Colors, as: Colors
  alias Phoenix.PubSub, as: PubSub
  alias Schema.SwarmLicense, as: SwarmLicense
  alias Schema.SwarmLicense.Status, as: Status

  alias License.Facts, as: LicenseFacts
  alias Scape.Facts, as: ScapeFacts

  alias TrainSwarmProc.InitializeLicense.EvtV1, as: Initialized
  alias TrainSwarmProc.ConfigureLicense.EvtV1, as: Configured
  alias TrainSwarmProc.PayLicense.EvtV1, as: Paid
  alias TrainSwarmProc.BlockLicense.EvtV1, as: LicenseBlocked
  alias TrainSwarmProc.ActivateLicense.EvtV1, as: Activated
  alias TrainSwarmProc.QueueLicense.EvtV1, as: LicenseQueued
  alias Cachex, as: Cachex

  require Logger

  @license_initialized_status Status.license_initialized()
  @license_configured_status Status.license_configured()
  @license_paid_status Status.license_paid()
  @licensed_activated_status Status.license_active()
  @license_blocked_status Status.license_blocked()
  @license_queued_status Status.license_queued()

  @license_facts LicenseFacts.license_facts()
  @license_cache_facts LicenseFacts.licenses_cache_facts()

  @license_initialized_v1 LicenseFacts.license_initialized()
  @license_configured_v1 LicenseFacts.license_configured()
  @license_paid_v1 LicenseFacts.license_paid()
  @license_blocked_v1 LicenseFacts.license_blocked()
  @license_queued_v1 LicenseFacts.license_queued()

  @scape_facts ScapeFacts.scape_facts()
  @scape_initialized_v1 ScapeFacts.scape_initialized_v1()

  @license_activated_v1 LicenseFacts.license_activated()

  ################## API ##################
  def count,
    do:
      GenServer.call(
        __MODULE__,
        :count
      )

  def get_all,
    do:
      GenServer.call(
        __MODULE__,
        :get_all
      )

  def get_all_for_user(user_id),
    do:
      GenServer.call(
        __MODULE__,
        {:get_all_for_user, user_id}
      )

  def get_all_queued,
    do:
      GenServer.call(
        __MODULE__,
        :get_all_queued
      )

  ############ INTERNALS ###############
  defp notify_swarm_licenses_updated(cause) do
    res =
      Swai.PubSub
      |> PubSub.broadcast!(@license_cache_facts, cause)

    Logger.alert("Notified SwarmLicense Cache Updated #{inspect(cause)} => #{inspect(res)}")
  end

  def save_to_disk() do
    GenServer.cast(
      __MODULE__,
      {:save_to_disk}
    )
  end

  def read_from_disk(path) do
    GenServer.cast(
      __MODULE__,
      {:read_from_disk, path}
    )
  end

  ################# COUNT ##############
  @impl true
  def handle_call(:count, _from, state) do
    {
      :reply,
      :swarm_licenses_db
      |> :khepri.count!("*"),
      state
    }
  end

  ################# GET_ALL_QUEUED ##############
  @impl true
  def handle_call(:get_all_queued, _from, state) do
    {
      :reply,
      :swarm_licenses_db
      |> :khepri.filter("*", fn st -> st.status |> Flags.has?(@license_queued_status) end)
      |> Enum.to_list(),
      state
    }
  end

  ################# GET_ALL ##############
  @impl true
  def handle_call(:get_all, _from, state) do
    {
      :reply,
      :swarm_licenses_cache
      |> Cachex.stream!()
      |> Enum.map(fn {:entry, _key, _nil, _internal_id, st} -> st end),
      state
    }
  end

  ################# GET_ALL_FOR_USER ##############
  @impl true
  def handle_call({:get_all_for_user, user_id}, _from, state) do
    {
      :reply,
      :swarm_licenses_cache
      |> Cachex.stream!()
      |> Enum.filter(fn {:entry, _key, _nil, _internal_id, st} ->
        st.user_id == user_id
      end)
      |> Enum.map(fn {:entry, _key, _nil, _internal_id, st} -> st end),
      state
    }
  end

  #################### TERMINATE ##################
  @impl true
  def terminate(reason, %{cache_file: path} = _state) do
    Logger.alert("Terminating SwarmLicense.Service. Reason: #{inspect(reason)}")

    res =
      :swarm_licenses_cache
      |> Cachex.dump!(path)

    Logger.alert("Dumped SwarmLicense Cache to [#{path}] => #{inspect(res)}")
    :ok
  end

  ################## SCAPE_INITIALIZED ###########
  @impl true
  def handle_info({@scape_initialized_v1, scape}, state) do
    {:noreply, state}
  end

  ################# LICENSE_INITIALIZED ###########
  @impl true
  def handle_info(
        {
          @license_initialized_v1,
          %Initialized{agg_id: agg_id, version: _version, payload: payload} = evt,
          metadata
        },
        state
      ) do
    Logger.alert("ADDING SwarmLicense due to #{inspect(evt)} with metadata #{inspect(metadata)}")
    seed = %SwarmLicense{license_id: agg_id, status: @license_initialized_status}

    case SwarmLicense.from_map(seed, payload) do
      {:ok, %SwarmLicense{} = license} ->
        if :swarm_licenses_cache
           |> Cachex.put!(agg_id, license) do
          notify_swarm_licenses_updated({@license_initialized_v1, license})
        end

      {:error, _reason} ->
        Logger.error("Failed to create SwarmLicense from #{inspect(payload)}")
    end

    {:noreply, state}
  end

  ################# HANDLE_CONFIGURED ###########
  @impl true
  def handle_info(
        {
          @license_configured_v1,
          %Configured{agg_id: agg_id, payload: configuration} = _evt,
          _metadata
        },
        state
      ) do
    license =
      :swarm_licenses_cache
      |> Cachex.get!(agg_id)

    case SwarmLicense.from_map(license, configuration) do
      {:ok, license} ->
        license = %SwarmLicense{license | status: @license_configured_status}

        if :swarm_licenses_cache
           |> Cachex.update!(agg_id, license) do
          notify_swarm_licenses_updated({@license_configured_v1, license})
        end

      {:error, _reason} ->
        Logger.error("Failed to update SwarmLicense from #{inspect(configuration)}")
    end

    {:noreply, state}
  end

  ################### HANDLE_LICENSE_PAID ###################
  @impl true
  def handle_info(
        {
          @license_paid_v1,
          %Paid{agg_id: agg_id, version: _version, payload: _payment} = evt,
          _metadata
        },
        state
      ) do
    Logger.alert("LICENSE PAID with event #{inspect(evt)}")

    license =
      :swarm_licenses_cache
      |> Cachex.get!(agg_id)

    license = %SwarmLicense{license | status: @license_paid_status}

    if :swarm_licenses_cache
       |> Cachex.update!(agg_id, license) do
      notify_swarm_licenses_updated({@license_paid_v1, license})
    end

    {:noreply, state}
  end

  ######################## LICENSE ACTIVATED ##############################
  @impl true
  def handle_info(
        {@license_activated_v1, %Activated{agg_id: agg_id} = evt, _metadata},
        state
      ) do
    Logger.alert("LICENSE ACTIVATED with event #{inspect(evt)}")

    license =
      :swarm_licenses_cache
      |> Cachex.get!(agg_id)

    license = %SwarmLicense{license | status: @licensed_activated_status}

    if :swarm_licenses_cache
       |> Cachex.update!(agg_id, license) do
      notify_swarm_licenses_updated({@license_activated_v1, license})
    end

    {:noreply, state}
  end

  ################### HANDLE_SCAPE_QUEUED ###################
  @impl true
  def handle_info(
        {@license_queued_v1, %LicenseQueued{agg_id: agg_id} = evt, _metadata},
        state
      ) do
    Logger.alert("SCAPE QUEUED with event #{inspect(evt)}")

    license =
      :swarm_licenses_cache
      |> Cachex.get!(agg_id)

    license = %SwarmLicense{license | status: @license_queued_status}

    if :swarm_licenses_cache
       |> Cachex.update!(agg_id, license) do
      notify_swarm_licenses_updated({@license_queued_v1, license})
    end

    {:noreply, state}
  end

  ################### HANDLE_LICENSE_BLOCKED ###################
  @impl true
  def handle_info(
        {@license_blocked_v1,
         %LicenseBlocked{agg_id: agg_id, version: _version, payload: block_info} = evt,
         _metadata},
        state
      ) do
    Logger.alert("LICENSE BLOCKED with event #{inspect(evt)}")

    license =
      :swarm_licenses_cache
      |> Cachex.get!(agg_id)

    license = %SwarmLicense{license | status: @license_blocked_status}

    if :swarm_licenses_cache
       |> Cachex.update!(agg_id, license) do
      notify_swarm_licenses_updated({@license_blocked_v1, license, block_info})
    end

    {:noreply, state}
  end

  ################# UNHANDLED_EVENTS ######
  @impl true
  def handle_info(msg, state) do
    Logger.warning("Unhandled event \n
    \n\t#{inspect(msg)}\n\n")
    {:noreply, state}
  end

  ################### PLUMBING ###################

  @impl true
  def init(args) do
    Process.flag(:trap_exit, true)

    Logger.info(
      "Starting SwarmLicense.Db with args #{inspect(args)} => #{Colors.scape_theme(self())}"
    )

    :swarm_licenses_db
    |> :khepri.start()

    Swai.PubSub
    |> PubSub.subscribe(@license_facts)

    Swai.PubSub
    |> PubSub.subscribe(@scape_facts)

    {:ok, args}
  end

  def child_spec(init_arg),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg]},
      type: :worker
    }

  def start_link(init_args),
    do:
      GenServer.start_link(
        __MODULE__,
        init_args,
        name: __MODULE__
      )
end

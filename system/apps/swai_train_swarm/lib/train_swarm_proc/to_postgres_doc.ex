defmodule TrainSwarmProc.ToPostgresDoc.V1 do
  @moduledoc """
  This module is responsible for handling the events emitted by the TrainSwarmProc
  aggregate and storing them in the Postgres database.
  """
  use Commanded.Event.Handler,
    name: "TrainSwarmProc.ToPostgresDoc.V1",
    application: TrainSwarmProc.CommandedApp,
    start_from: :origin

  alias Swai.Accounts
  alias Schema.SwarmLicense, as: SwarmLicense
  alias Swai.Workspace, as: MyWorkspace

  alias TrainSwarmProc.InitializeLicense.EvtV1, as: Initialized
  alias TrainSwarmProc.ConfigureLicense.EvtV1, as: Configured
  alias TrainSwarmProc.PayLicense.EvtV1, as: LicensePaid
  alias TrainSwarmProc.BlockLicense.EvtV1, as: LicenseBlocked

  alias TrainSwarmProc.ActivateLicense.EvtV1, as: LicenseActivated
  alias TrainSwarmProc.QueueLicense.EvtV1, as: LicenseQueued

  alias Schema.SwarmLicense.Status, as: Status

  require Logger

  @license_initialized_status Status.license_initialized()
  @license_configured_status Status.license_configured()
  @license_paid_status Status.license_paid()
  @license_blocked_status Status.license_blocked()
  @license_activated_status Status.license_active()

  @license_queued_status Status.license_queued()

  ####################### INITIALIZED #######################
  @impl true
  def handle(
        %Initialized{
          agg_id: agg_id,
          payload: payload
        } = _evt,
        _metadata
      ) do
    payload =
      payload
      |> Map.put(:id, agg_id)
      |> Map.put(:status, @license_initialized_status)

    MyWorkspace.create_swarm_license(payload)

    :ok
  end

  ####################### CONFIGURED #######################
  @impl true
  def handle(
        %Configured{
          agg_id: agg_id,
          payload: payload
        } = evt,
        _metadata
      ) do
    Logger.debug("Handling Configured event => #{inspect(evt)}")
    st = MyWorkspace.get_swarm_license!(agg_id)

    case SwarmLicense.from_map(st, payload) do
      {:ok, st} ->
        new_st = %{st | status: @license_configured_status}

        new_st
        |> MyWorkspace.update_swarm_license(payload)

        :ok

      {:error, changeset} ->
        Logger.error("Invalid license request params #{inspect(changeset)}")
        {:error, "Invalid license request params #{inspect(changeset)}"}
    end
  end

  ######################## LICENSE PAID ########################
  @impl true
  def handle(
        %LicensePaid{
          agg_id: agg_id,
          payload: payload
        } = evt,
        _metadata
      ) do
    Logger.alert("Handling LicensePaid event => #{inspect(evt)}")

    sl = MyWorkspace.get_swarm_license!(agg_id)

    Logger.alert("Payload => #{inspect(payload)}")

    case SwarmLicense.from_map(sl, payload) do
      {:ok, sl} ->

        sl = %{sl | status: @license_paid_status}
        sl
        |> MyWorkspace.update_swarm_license(payload)

        Accounts.decrease_user_budget(payload.user_id, payload.cost_in_tokens)

        :ok

      {:error, changeset} ->
        Logger.error("Invalid license request params #{inspect(changeset)}")
        {:error, "Invalid license request params #{inspect(changeset)}"}
    end
  end

  ############ LICENSE ACTIVATED ################
  @impl true
  def handle(
        %LicenseActivated{
          agg_id: agg_id,
          payload: payload
        } = evt,
        _metadata
      ) do
    Logger.debug("Handling LicenseActivated event => #{inspect(evt)}")
    st = MyWorkspace.get_swarm_license!(agg_id)

    case SwarmLicense.from_map(st, payload) do
      {:ok, st} ->
        new_st = %{st | status: @license_activated_status}

        new_st
        |> MyWorkspace.update_swarm_license(payload)

        :ok

      {:error, changeset} ->
        Logger.error("Invalid license request params #{inspect(changeset)}")
        {:error, "Invalid license request params #{inspect(changeset)}"}
    end
  end

  ############################# SCAPE QUEUED #############################
  @impl true
  def handle(
        %LicenseQueued{
          agg_id: agg_id,
          payload: payload
        } = evt,
        _metadata
      ) do
    Logger.debug("Handling LicenseQueued event => #{inspect(evt)}")
    st = MyWorkspace.get_swarm_license!(agg_id)

    case SwarmLicense.from_map(st, payload) do
      {:ok, st} ->
        new_st = %{st | status: @license_queued_status}

        new_st
        |> MyWorkspace.update_swarm_license(payload)

        :ok

      {:error, changeset} ->
        Logger.error("Invalid license request params #{inspect(changeset)}")
        {:error, "Invalid license request params #{inspect(changeset)}"}
    end
  end

  ############################ LICENSE BLOCKED ############################
  @impl true
  def handle(
        %LicenseBlocked{
          agg_id: agg_id,
          payload: payload
        } = evt,
        _metadata
      ) do
    Logger.debug("Handling LicenseBlocked event => #{inspect(evt)}")
    st = MyWorkspace.get_swarm_license!(agg_id)

    case SwarmLicense.from_map(st, payload) do
      {:ok, st} ->
        new_st = %{st | status: @license_blocked_status}

        new_st
        |> MyWorkspace.update_swarm_license(payload)

        :ok

      {:error, changeset} ->
        Logger.error("Invalid license request params #{inspect(changeset)}")
        {:error, "Invalid license request params #{inspect(changeset)}"}
    end
  end

  ####################### UNHANDLED EVENTS #######################
  @impl true
  def handle(msg, _metadata) do
    Logger.warning("Unhandled event #{inspect(msg)}")
    :ok
  end
end

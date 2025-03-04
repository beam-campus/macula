defmodule TrainSwarmProc.Aggregate do
  @moduledoc """
  This module defines the aggregate for the Train Swarm Process.
  """
  use Ecto.Schema

  alias Schema.SwarmLicense, as: SwarmLicense
  alias Schema.SwarmLicense.Status, as: LicenseStatus

  alias TrainSwarmProc.ActivateLicense.EvtV1, as: LicenseActivated
  alias TrainSwarmProc.Aggregate, as: Aggregate
  alias TrainSwarmProc.BlockLicense.EvtV1, as: LicenseBlocked
  alias TrainSwarmProc.ConfigureLicense.EvtV1, as: LicenseConfigured
  alias TrainSwarmProc.InitializeLicense.EvtV1, as: LicenseInitialized
  alias TrainSwarmProc.PauseLicense.EvtV1, as: LicensePaused
  alias TrainSwarmProc.PayLicense.EvtV1, as: LicensePaid
  alias TrainSwarmProc.QueueLicense.EvtV1, as: LicenseQueued
  alias TrainSwarmProc.ReserveLicense.EvtV1, as: LicenseReserved
  alias TrainSwarmProc.StartLicense.EvtV1, as: LicenseStarted

  require Jason.Encoder
  require Logger

  @proc_unknown LicenseStatus.unknown()
  @license_initialized_status LicenseStatus.license_initialized()
  @license_configured_status LicenseStatus.license_configured()
  @license_paid_status LicenseStatus.license_paid()
  @license_active_status LicenseStatus.license_active()
  @license_blocked_status LicenseStatus.license_blocked()

  @license_queued_status LicenseStatus.license_queued()
  @license_started_status LicenseStatus.license_started()
  @license_reserved_status LicenseStatus.license_reserved()
  @license_paused_status LicenseStatus.license_paused()

  @all_fields [
    :agg_id,
    :status,
    :state
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:agg_id, :binary_id)
    field(:status, :integer, default: @proc_unknown)
    embeds_one(:state, SwarmLicense)
  end

  ###################  LICENSE INITIALIZED  ###################
  def apply(
        %Aggregate{state: nil},
        %LicenseInitialized{payload: payload} = evt
      ) do
    case SwarmLicense.from_map(%SwarmLicense{}, payload) do
      {:ok, new_license} ->
        %Aggregate{
          agg_id: evt.agg_id,
          status: @license_initialized_status,
          state: new_license
        }

      {:error, changeset} ->
        Logger.error("invalid license INITIALIZATION

          event => #{inspect(evt)}

          changeset => #{inspect(changeset)}

          ")
        {:error, "invalid license initialization"}
    end
  end

  ##################### LICENSE CONFIGURED #####################
  def apply(
        %Aggregate{state: license} = agg,
        %LicenseConfigured{payload: configuration} = evt
      ) do
    case SwarmLicense.from_map(license, configuration) do
      {:ok, new_license} ->
        %Aggregate{
          agg
          | status:
              agg.status
              |> Flags.set(@license_configured_status),
            state: new_license
        }

      {:error, changeset} ->
        Logger.error("invalid license CONFIGURATION
          event => #{inspect(evt)}

          changeset => #{inspect(changeset)}")
        {:error, "invalid license configuration"}
    end
  end

  ##################### LICENSE PAID #####################
  def apply(
        %Aggregate{state: license} = agg,
        %LicensePaid{payload: payment} = evt
      ) do
    case SwarmLicense.from_map(license, payment) do
      {:ok, new_license} ->
        %Aggregate{
          agg
          | status:
              agg.status
              |> Flags.set(@license_paid_status),
            state: new_license
        }

      {:error, changeset} ->
        Logger.error("invalid license PAYMENT

          event => #{inspect(evt)}

          changeset => #{inspect(changeset)}

          ")
        {:error, "invalid license PAYMENT"}
    end
  end

  ##################### LICENSE ACTIVATED #####################
  def apply(
        %Aggregate{state: license} = agg,
        %LicenseActivated{payload: activation} = evt
      ) do
    case SwarmLicense.from_map(license, activation) do
      {:ok, new_license} ->
        %Aggregate{
          agg
          | status:
              agg.status
              |> Flags.set(@license_active_status),
            state: new_license
        }

      {:error, changeset} ->
        Logger.error(
          "invalid license ACTIVATION \n\n event => \n#{inspect(evt)} \n\nchangeset => \n#{inspect(changeset)}"
        )

        {:error, "invalid license activation"}
    end
  end

  ####################### LICENSE QUEUED #######################
  def apply(
        %Aggregate{state: seed} = agg,
        %LicenseQueued{payload: payload} = evt
      ) do
    case SwarmLicense.from_map(seed, payload) do
      {:ok, new_license} ->
        %Aggregate{
          agg
          | status:
              agg.status
              |> Flags.set(@license_queued_status)
              |> Flags.unset_all([
                @license_paused_status,
                @license_reserved_status,
                @license_started_status
              ]),
            state: new_license
        }

      {:error, changeset} ->
        Logger.error("invalid scape queued
          event => #{inspect(evt)}

          changeset => #{inspect(changeset)}
          ")
        {:error, "invalid scape queued"}
    end
  end

  ###################### LICENSE_BLOCKED ######################
  def apply(
        %Aggregate{state: license} = agg,
        %LicenseBlocked{payload: block_info} = evt
      ) do
    case SwarmLicense.from_map(license, block_info) do
      {:ok, new_license} ->
        %Aggregate{
          agg
          | status:
              agg.status
              |> Flags.set(@license_blocked_status)
              |> Flags.unset_all([
                @license_paid_status,
                @license_queued_status,
                @license_paused_status,
                @license_reserved_status,
                @license_started_status
              ]),
            state: new_license
        }

      {:error, changeset} ->
        Logger.error("invalid license BLOCKING

          event => #{inspect(evt)}

          changeset => #{inspect(changeset)}

          ")
        {:error, "invalid license block"}
    end
  end

  ######################## LICENSE RESERVED #####################
  def apply(
        %Aggregate{state: license} = agg,
        %LicenseReserved{payload: payload} = evt
      ) do
    case SwarmLicense.from_map(license, payload) do
      {:ok, new_license} ->
        %Aggregate{
          agg
          | status:
              agg.status
              |> Flags.unset_all([
                @license_queued_status,
                @license_paused_status,
                @license_started_status
              ])
              |> Flags.set(@license_reserved_status),
            state: new_license
        }

      {:error, changeset} ->
        Logger.error("invalid license RESERVATION

          event => #{inspect(evt)}

          changeset => #{inspect(changeset)}

          ")
        {:error, "invalid license reservation"}
    end
  end

  ####################### LICENSE STARTED #######################
  def apply(
        %Aggregate{state: license} = agg,
        %LicenseStarted{payload: scape} = evt
      ) do
    case SwarmLicense.from_map(license, scape) do
      {:ok, new_license} ->
        %Aggregate{
          agg
          | status:
              agg.status
              |> Flags.unset_all([
                @license_reserved_status,
                @license_paused_status,
                @license_queued_status
              ])
              |> Flags.set(@license_started_status),
            state: new_license
        }

      {:error, changeset} ->
        Logger.error("Bad Event Payload

          event => #{inspect(evt)}

          changeset => #{inspect(changeset)}")
        {:error, "Bad Event Payload"}
    end
  end

  ########################### LICENSE  PAUSED ###########################
  def apply(
        %Aggregate{state: license} = agg,
        %LicensePaused{payload: payload} = evt
      ) do
    case SwarmLicense.from_map(license, payload) do
      {:ok, new_license} ->
        %Aggregate{
          agg
          | status:
              agg.status
              |> Flags.unset_all([
                @license_started_status,
                @license_reserved_status,
                @license_queued_status
              ])
              |> Flags.set(@license_paused_status),
            state: new_license
        }

      {:error, changeset} ->
        Logger.error("invalid scape paused

          event => #{inspect(evt)}

          changeset => #{inspect(changeset)}

          ")
        {:error, "invalid scape paused"}
    end
  end

  ####################### UNKNOWN EVENT #######################
  def apply(agg, evt) do
    Logger.warning("Unknown event => #{inspect(evt)}")
    agg
  end
end

defmodule TrainSwarmProc.ToPubSubV1 do
  @moduledoc """
  This module is responsible for handling the events that are emitted by the TrainSwarmProc
  and broadcasting them to the Phoenix.PubSub
  """
  use Commanded.Event.Handler,
    name: __MODULE__,
    application: TrainSwarmProc.CommandedApp,
    start_from: :origin

  alias Schema.User
  alias Swai.Accounts

  alias TrainSwarmProc.ActivateLicense.EvtV1, as: LicenseActivated
  alias TrainSwarmProc.BlockLicense.EvtV1, as: LicenseBlocked
  alias TrainSwarmProc.ConfigureLicense.EvtV1, as: LicenseConfigured
  alias TrainSwarmProc.InitializeLicense.EvtV1, as: LicenseInitialized
  alias TrainSwarmProc.PauseLicense.EvtV1, as: LicensePaused
  alias TrainSwarmProc.PayLicense.EvtV1, as: LicensePaid
  alias TrainSwarmProc.QueueLicense.EvtV1, as: LicenseQueued
  alias TrainSwarmProc.StartLicense.EvtV1, as: LicenseStarted

  alias License.Facts, as: LicenseFacts

  alias Phoenix.PubSub, as: PubSub

  require Logger

  @license_facts LicenseFacts.license_facts()
  @license_initialized LicenseFacts.license_initialized()
  @license_configured LicenseFacts.license_configured()
  @license_paid LicenseFacts.license_paid()
  @license_activated LicenseFacts.license_activated()
  @license_blocked LicenseFacts.license_blocked()

  @license_queued_v1 LicenseFacts.license_queued()
  @license_started_v1 LicenseFacts.license_started()
  @license_paused_v1 LicenseFacts.license_paused()

  ###################### License INITIALIZED ######################
  @impl true
  def handle(%LicenseInitialized{} = evt, metadata) do
    Swai.PubSub
    |> PubSub.broadcast(@license_facts, {@license_initialized, evt, metadata})

    :ok
  end

  ####################### CONFIGURED #######################
  @impl true
  def handle(%LicenseConfigured{} = evt, metadata) do
    Swai.PubSub
    |> PubSub.broadcast!(@license_facts, {@license_configured, evt, metadata})

    :ok
  end

  ########################### LICENSE PAID ############################
  @impl true
  def handle(%LicensePaid{payload: %{user_id: user_id} = payment} = evt, metadata) do
    %User{email: user_email} = Accounts.get_user!(user_id)

    case String.contains?(user_email, "@discomco.pl") do
      true ->
        Logger.debug("User with email #{user_email} is from DisComCo and may swarm for free")

      false ->
        Accounts.decrease_user_budget(user_id, payment.cost_in_tokens)
    end

    Swai.PubSub
    |> PubSub.broadcast!(@license_facts, {@license_paid, evt, metadata})

    :ok
  end

  ############################## LICENSE ACTIVATED ##############################
  @impl true
  def handle(%LicenseActivated{} = evt, metadata) do
    Swai.PubSub
    |> PubSub.broadcast!(@license_facts, {@license_activated, evt, metadata})

    :ok
  end

  ############################ LICENSE BLOCKED ############################
  @impl true
  def handle(%LicenseBlocked{} = evt, metadata) do
    Swai.PubSub
    |> PubSub.broadcast!(@license_facts, {@license_blocked, evt, metadata})

    :ok
  end

  ############################ LICENSE QUEUED ############################
  @impl true
  def handle(%LicenseQueued{} = evt, metadata) do
    Swai.PubSub
    |> PubSub.broadcast!(@license_facts, {@license_queued_v1, evt, metadata})

    :ok
  end

  ################################ LICENSE STARTED ########################
  @impl true
  def handle(%LicenseStarted{} = evt, metadata) do
    Swai.PubSub
    |> PubSub.broadcast!(@license_facts, {@license_started_v1, evt, metadata})

    :ok
  end

  ############################ LICENSE PAUSED #############################
  @impl true
  def handle(%LicensePaused{} = evt, metadata) do
    Swai.PubSub
    |> PubSub.broadcast!(@license_facts, {@license_paused_v1, evt, metadata})
    :ok
  end

  ####################### UNHANDLED EVENTS #######################
  @impl true
  def handle(msg, _metadata) do
    Logger.warning("Unhandled event #{inspect(msg)}")
    :ok
  end

end

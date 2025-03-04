defmodule TrainSwarmProc.Policies do
  @moduledoc """
  Commanded process manager for starting the swarm training process.
  """
  use Commanded.ProcessManagers.ProcessManager,
    application: TrainSwarmProc.CommandedApp,
    name: "TrainSwarmProc.Policies"

  @all_fields [
    :agg_id,
    :state
  ]

  require Jason.Encoder

  @derive {Jason.Encoder, only: @all_fields}
  defstruct [
    :agg_id,
    :state
  ]

  alias TrainSwarmProc.Policies, as: Policies

  alias TrainSwarmProc.ConfigureLicense.EvtV1, as: LicenseConfigured

  alias Schema.SwarmLicense, as: Activation
  alias Schema.SwarmLicense, as: License
  alias Schema.SwarmLicense, as: Payment
  alias TrainSwarmProc.ActivateLicense.CmdV1, as: Activate
  alias TrainSwarmProc.ActivateLicense.EvtV1, as: LicenseActivated
  alias TrainSwarmProc.DetachScape.EvtV1, as: ScapeDetached
  alias TrainSwarmProc.PauseLicense.CmdV1, as: PauseLicense
  alias TrainSwarmProc.PayLicense.BudgetReachedV1, as: BudgetReached
  alias TrainSwarmProc.PayLicense.CmdV1, as: PayLicense
  alias TrainSwarmProc.PayLicense.EvtV1, as: Paid
  alias TrainSwarmProc.QueueLicense.CmdV1, as: QueueLicense

  require Logger

  def interested?(%LicenseConfigured{} = event), do: {:start, event}
  def interested?(%Paid{} = event), do: {:start, event}
  def interested?(%BudgetReached{} = event), do: {:start, event}
  def interested?(%LicenseActivated{} = event), do: {:start, event}
  def interested?(%ScapeDetached{} = event), do: {:start, event}

  def interested?(_event), do: false

  #################### HANDLE INCOMING EVENTS AND THROW THE COMMANDS ####################

  # POLICY: License CONFIGURATION triggers License PAYMENT
  def handle(
        %Policies{} = _policies,
        %LicenseConfigured{agg_id: agg_id, payload: configuration} = _event
      ) do
    case Payment.from_map(%Payment{}, configuration) do
      {:ok, payment} ->
        %PayLicense{agg_id: agg_id, payload: payment}

      {:error, changeset} ->
        Logger.error("invalid configuration for payment \n #{inspect(changeset)}")
        {:error, "invalid configuration"}
    end
  end

  # POLICY: License PAYMENT triggers License ACTIVATION
  def handle(
        %Policies{} = _policies,
        %Paid{agg_id: agg_id, payload: payment} = _event
      ) do
    case Activation.from_map(%Activation{}, payment) do
      {:ok, activation} ->
        %Activate{agg_id: agg_id, payload: activation}

      {:error, changeset} ->
        Logger.error("invalid payment for activation\n #{inspect(changeset)}")
        {:error, "invalid payment, cannot activate"}
    end
  end

  # POLICY: License ACTIVATION triggers License QUEUING
  def handle(
        %Policies{} = _policies,
        %LicenseActivated{agg_id: agg_id, payload: activation} = _event
      ) do
    seed =
      %License{}

    case License.from_map(seed, activation) do
      {:ok, license} ->
        %QueueLicense{agg_id: agg_id, payload: license}

      {:error, changeset} ->
        Logger.error("invalid activation for license queuing\n #{inspect(changeset)}")
        {:error, "invalid activation, cannot queue license"}
    end
  end

  # POLICY: Scape DETACHEMENT triggers License PAUSING ########################
  def handle(
        %Policies{} = _policies,
        %ScapeDetached{agg_id: agg_id, payload: scape_init} = _event
      ) do
    %PauseLicense{
      agg_id: agg_id,
      version: 1,
      payload: scape_init
    }
  end

  # Stop Policies after three failures
  def error({:error, _failure}, _failed_message, %{context: %{failures: failures}})
      when failures >= 4 do
    {:stop, :too_many_failures}
  end

  # Retry command, record failure count in context map
  def error({:error, _failure}, _failed_message, %{context: context}) do
    context = Map.update(context, :failures, 1, fn failures -> failures + 1 end)
    {:retry, context}
  end
end

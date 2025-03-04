defmodule TrainSwarmProc.PayLicense.BudgetInfoV1 do
  @moduledoc """
  This module defines the BudgetInfo for the Train Swarm Process.
  """
  use Ecto.Schema

  import Ecto.Changeset

  require Logger
  require Jason.Encoder

  alias TrainSwarmProc.PayLicense.BudgetInfoV1, as: BudgetInfo

  @all_fields [
    :user_id,
    :license_id,
    :current_budget,
    :required_budget,
  ]

  @flat_fields [
    :user_id,
    :license_id,
    :current_budget,
    :required_budget,
  ]


  @required_fields [
    :user_id,
    :license_id,
    :current_budget,
    :required_budget,
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:user_id, :binary_id)
    field(:license_id, :binary_id)
    field(:current_budget, :integer)
    field(:required_budget, :integer)
  end

  def changeset(%BudgetInfo{} = seed, attrs) when is_struct(attrs),
    do: changeset(seed, Map.from_struct(attrs))

  def changeset(%BudgetInfo{} = seed, attrs) when is_map(attrs) do
    seed
    |> cast(attrs, @flat_fields)
    |> validate_required(@required_fields)
  end

  def from_map(seed, map) when is_struct(map),
    do: from_map(seed, Map.from_struct(map))

  def from_map(%BudgetInfo{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create BudgetInfo from map: #{inspect(map)}")
        {:error, changeset}
    end
  end


end

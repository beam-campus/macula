defmodule TrainSwarmProc.ActivateLicense.CmdV1 do
  @moduledoc """
  Command module for activating the swarm training process.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias TrainSwarmProc.ActivateLicense.CmdV1, as: Activate
  alias Schema.SwarmLicense, as: Activation

  require Logger
  require Jason.Encoder

  @all_fields [
    :agg_id,
    :version,
    :payload
  ]

  @flat_fields [
    :agg_id,
    :version
  ]

  @required_fields [
    :agg_id,
    :version,
    :payload
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:agg_id, :binary_id)
    field(:version, :integer, default: 1)
    embeds_one(:payload, Activation)
  end

  def changeset(%Activate{} = cmd, attrs) do
    cmd
    |> cast(attrs, @flat_fields)
    |> cast_embed(:payload, with: &Activation.changeset/2)
    |> validate_required(@required_fields)
  end

  def from_map(%Activate{} = seed, map) when is_struct(map) do
    from_map(seed, Map.from_struct(map))
  end

  def from_map(%Activate{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create Activate from map: #{inspect(changeset)}")
        {:error, changeset}
    end
  end




end

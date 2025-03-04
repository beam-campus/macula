defmodule TrainSwarmProc.ActivateLicense.EvtV1 do
  @moduledoc """
  The schema for the Activated event.
  """

  use Ecto.Schema

  import Ecto.Changeset

  require Logger
  require Jason.Encoder

  alias TrainSwarmProc.ActivateLicense.EvtV1, as: Activated
  alias Schema.SwarmLicense, as: Activation


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

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:agg_id, :binary_id)
    field(:version, :integer, default: 1)
    embeds_one(:payload, Activation)
  end

  def changeset(%Activated{} = seed, %{} = attrs) when is_struct(attrs) do
    changeset(seed, Map.from_struct(attrs))
  end
  def changeset(%Activated{} = payload, %{} = attrs) when is_map(attrs) do
    payload
    |> cast(attrs, @flat_fields)
    |> cast_embed(:payload, with: &Activation.changeset/2)
    |> validate_required(@required_fields)
  end

  def from_map(%Activated{} = seed, %{} = map) when is_struct(map) do
    from_map(seed, Map.from_struct(map))
  end
  def from_map(%Activated{} = seed, %{} = map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create Activated from map: #{inspect(map)}")
        {:error, changeset}
    end
  end


end

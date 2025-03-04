defmodule TrainSwarmProc.QueueLicense.CmdV1 do
  @moduledoc """
  Command to start a swarm training.
  """
  use Ecto.Schema

  alias TrainSwarmProc.QueueLicense
  alias TrainSwarmProc.QueueLicense.CmdV1, as: QueueLicense
  alias Schema.SwarmLicense, as: License

  import Ecto.Changeset

  require Jason.Encoder
  require Logger

  @all_fields [:agg_id, :payload]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:agg_id, :binary_id)
    embeds_one(:payload, License)
  end

  def changeset(%QueueLicense{} = seed, %{} = map)
      when is_map(map) do
    seed
    |> cast(map, @all_fields)
    |> cast_embed(:payload, with: &QueueLicense.changeset/2)
    |> validate_required(@all_fields)
  end

  def from_map(%QueueLicense{} = seed = %QueueLicense{}, %{} = struct)
      when is_struct(struct) do
    from_map(seed, Map.from_struct(struct))
  end

  def from_map(%QueueLicense{} = seed, %{} = map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        changeset
        |> apply_changes()

      changeset ->
        Logger.error("Failed to create Start from map: #{inspect(changeset)}")
        {:error, changeset}
    end
  end
end

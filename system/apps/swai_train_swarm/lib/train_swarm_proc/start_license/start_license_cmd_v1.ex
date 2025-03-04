defmodule TrainSwarmProc.StartLicense.CmdV1 do
  @moduledoc """
  Command to start a swarm training.
  """
  use Ecto.Schema

  alias Schema.SwarmLicense, as: License

  import Ecto.Changeset

  require Jason.Encoder
  require Logger

  @all_fields [
    :agg_id,
    :version,
    :payload
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:agg_id, :binary_id)
    field(:version, :integer, default: 1)
    embeds_one(:payload, License)
  end

  def changeset(seed, nil), do: seed

  def changeset(seed, attrs)
      when is_struct(attrs) do
    changeset(seed, Map.from_struct(attrs))
  end

  def changeset(seed, %{} = attrs)
      when is_map(attrs) do
    seed
    |> cast(attrs, @all_fields)
    |> cast_embed(:payload, with: &License.changeset/2)
    |> validate_required(@all_fields)
  end

  def from_map(seed, map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, changeset |> apply_changes()}

      changeset ->
        Logger.error("Failed to create Start from map: #{inspect(map)}")
        {:error, changeset}
    end
  end
end

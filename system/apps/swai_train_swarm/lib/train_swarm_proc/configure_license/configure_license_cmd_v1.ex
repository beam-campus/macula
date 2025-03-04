defmodule TrainSwarmProc.ConfigureLicense.CmdV1 do
  @moduledoc """
  Cmd module for configuring the swarm training process.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias TrainSwarmProc.ConfigureLicense.CmdV1, as: Configure
  alias Schema.SwarmLicense, as: Configuration

  @all_fields [
    :agg_id,
    :version,
    :payload
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:agg_id, :binary_id)
    field(:version, :integer, default: 1)
    embeds_one(:payload, Configuration)
  end

  def changeset(%Configure{} = cmd, attrs) do
    cmd
    |> cast(attrs, @all_fields)
    |> cast_embed(:payload, with: &Configuration.changeset/2)
    |> validate_required(@all_fields)
  end

  def from_map(%Configure{} = seed, map) when is_struct(map),
    do: from_map(seed, Map.from_struct(map))

  def from_map(%Configure{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create Configure from map: #{inspect(map)}")
        {:error, changeset}
    end
  end


end

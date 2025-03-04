defmodule TrainSwarmProc.PauseLicense.CmdV1 do
  @moduledoc """
  This module is responsible for handling the commands that are emitted by the TrainSwarmProc
  and broadcasting them to the Phoenix.PubSub
  """
  use Ecto.Schema

  alias Schema.SwarmLicense, as: License
  alias TrainSwarmProc.PauseLicense.CmdV1, as: PauseLicense

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

  def changeset(%PauseLicense{} = seed, %{} = attrs)
      when is_struct(attrs) do
    changeset(seed, Map.from_struct(attrs))
  end

  def changeset(%PauseLicense{} = seed, %{} = attrs)
      when is_map(attrs) do
    seed
    |> cast(attrs, @all_fields)
    |> cast_embed(:payload, with: &License.changeset/2)
    |> validate_required(@all_fields)
  end

  def from_map(%PauseLicense{} = seed, %{} = map)
      when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        changeset
        |> apply_changes()

      changeset ->
        Logger.error("Failed to create PauseLicense from map: #{inspect(map)}")
        {:error, changeset}
    end
  end
end

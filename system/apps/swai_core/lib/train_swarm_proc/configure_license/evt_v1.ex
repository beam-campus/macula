defmodule TrainSwarmProc.ConfigureLicense.EvtV1 do
  @moduledoc """
  Documentation for `EvtV1`.
  """
  use Ecto.Schema

  import Ecto.Changeset

  require Jason.Encoder
  require Logger

  alias Schema.SwarmLicense, as: Configuration
  alias TrainSwarmProc.ConfigureLicense.EvtV1, as: Configured

  @all_fields [
    :agg_id,
    :version,
    :payload
  ]

  @flat_fields [
    :agg_id,
    :version
  ]


  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:agg_id, :binary_id)
    field(:version, :integer, default: 1)
    embeds_one(:payload, Configuration)
  end

  def changeset(%Configured{} = evt, %{} = attrs) do
    evt
    |> cast(attrs, @flat_fields)
    |> cast_embed(:payload, with: &Configuration.changeset/2)
    |> validate_required(@all_fields)
  end

  def from_map(%Configured{} = seed, map) when is_struct(map),
    do: from_map(seed, Map.from_struct(map))

  def from_map(%Configured{} = seed, map) when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create Configure from map: #{inspect(map)}")
        {:error, changeset}
    end
  end

  defimpl String.Chars,
    for: Con do
    def to_string(evt) do
      Jason.encode!(evt)
    end
  end
end

defmodule Schema.Motion do
  use Ecto.Schema

  alias Schema.Vector, as: Vector

  alias Schema.Motion, as: Motion

  import Ecto.Changeset

  @moduledoc """
  the payload for the edge:attached:v1 fact
  """

  @all_fields [
    :born2died_id,
    :mng_farm_id,
    :edge_id,
    :from,
    :to,
    :delta_t
  ]

  @flat_fields [
    :edge_id,
    :mng_farm_id,
    :born2died_id,
    :delta_t
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}

  embedded_schema do
    field(:born2died_id, :string)
    field(:edge_id, :string)
    field(:mng_farm_id, :string)
    field(:delta_t, :integer)
    embeds_one(:to, Vector)
    embeds_one(:from, Vector)
  end

  def from_map(map) when is_map(map) do
    case changeset(%Motion{}, map) do
      %{valid?: true} = changeset ->
        state =
          changeset
          |> Ecto.Changeset.apply_changes()

        {:ok, state}

      changeset ->
        {:error, changeset}
    end
  end

  def changeset(%Motion{} = motion, attrs) do
    motion
    |> cast(attrs, @all_fields)
    |> validate_required(@flat_fields)
  end
end

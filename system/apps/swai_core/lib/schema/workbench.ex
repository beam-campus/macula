defmodule Schema.Workbench do
  @moduledoc false
  use Ecto.Schema

  require Logger

  import Ecto.Changeset

  alias Schema.SwarmLicense, as: License
  alias Schema.Payment, as: Payment
  alias Schema.Scape, as: Scape

  @all_fields [
    :id,
    :name,
    :description,
    :status
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:user_id, :binary_id)
    field(:name, :string)
    field(:description, :string)
    field(:status, :integer)
    embeds_one(:license, License)
    embeds_many(:payments, Payment)
    embeds_one(:scape, Scape)
  end

  def changeset(workbench, params \\ %{}) do
    workbench
    |> cast(params, @all_fields)
    |> cast_embed(:license)
    |> cast_embed(:scape)
    |> cast_embed(:payments)
    |> validate_required(@all_fields)
    |> validate_length(:name, min: 3, max: 100)
    |> validate_length(:description, min: 3, max: 1000)
    |> validate_inclusion(:status, [0, 1, 2])
  end

  def from_map(seed, struct) when is_struct(struct) do
    from_map(seed, Map.from_struct(struct))
  end

  def from_map(seed, map) when is_map(map) do
    case changeset(seed, map) do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Error creating workbench: #{inspect(changeset)}")
        {:error, changeset}
    end
  end
end

defmodule Schema.Id do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema.Id is a module that contains the schema for a given Id
  """

  @all_fields [:prefix, :value]

  alias Schema.Id

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:prefix, :string)
    field(:value, :string)
  end

  def as_string(%{prefix: p, value: v} = _id),
    do: p <> "-" <> v

  def changeset(id, args) do
    id
    |> cast(args, @all_fields)
    |> validate_required(@all_fields)
  end

  def new(prefix, value) do
    %Id{
      prefix: prefix,
      value: value
    }
  end

  def new(prefix) when is_binary(prefix) do
    new(prefix, UUID.uuid4())
  end

  def new(args) when is_map(args) do
    case changeset(%Id{}, args) do
      %{valid?: true} = changeset ->
        changeset
        |> Ecto.Changeset.apply_changes()

      changeset ->
        {:error, changeset}
    end
  end
end

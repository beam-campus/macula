defmodule Service.Scapes.Scape do
  use Ecto.Schema

  @moduledoc """
  Service.Scapes.Scape contains the Ecto schema for the Scape.
  """
  import Ecto.Changeset

  require Logger


  alias Service.Scapes.Scape

  @cast_fields [
    :id,
    :name
  ]

  @required_fields [
    :id,
    :name,
    :status
  ]

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    field(:status, :string)
    embeds_many(:regions, Service.Scapes.Region)
    embeds_many(:sourced_by, :string)
  end

  def empty() do
    %Scape{
      id: "",
      name: "",
      status: "unknown",
      regions: [],
      sourced_by: []
    }
  end

  def changeset(scape, args)
      when is_map(args) do
    scape
    |> cast(args, @cast_fields)
    |> validate_required(@required_fields)
  end

  def from_map(map) when is_map(map) do
    case(changeset(Scape.empty(), map)) do
      %{valid?: true} = changeset ->
        scape =
          changeset
          |> apply_changes()

        {:ok, scape}

      changeset ->
        {:error, changeset}
    end
  end

  def add_source(scape, edge_id) do
    case Enum.member?(scape.sourced_by, edge_id) do
      false ->
        scape =
          %{ scape | sourced_by: [edge_id | scape.sourced_by] }
        {:ok, scape}
      true ->
        {:ok, scape}
    end
  end

  # def add_source(scape, edge_id) do
  #   case Ecto.Changeset.change(scape) do
  #     %{valid?: true} = changeset ->
  #       Logger.error("\n Scape: #{inspect(scape)}")
  #       Logger.error("\n Edge ID: #{inspect(edge_id)}")
  #       Logger.error("\n Scape sourced by: #{inspect(scape.sourced_by)}")

  #       case Enum.member?(scape.sourced_by, edge_id) do
  #         false ->
  #           new_sources = [edge_id | scape.sourced_by]

  #           scape
  #           |> put_embed(:sourced_by, new_sources, [])
  #           |> apply_changes()

  #         true ->
  #           scape
  #       end

  #       Logger.error("\n Scape: #{inspect(scape)}")
  #       {:ok, scape}

  #     changeset ->
  #       {:error, changeset}
  #   end
  # end
end

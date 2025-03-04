defmodule Scape.Init do
  @moduledoc """
  Scape.InitParams is a struct that holds the parameters for initializing a scape.
  """
  use Ecto.Schema

  import Ecto.Changeset
  require MnemonicSlugs
  require Jason.Encoder
  require Logger

  alias Arena.Init, as: ArenaInit
  alias Hive.Init, as: HiveInit
  alias Scape.Init, as: ScapeInit
  alias Scape.Status, as: ScapeStatus
  alias NameUtils, as: NameUtils

  @all_fields [
    :scape_id,
    :scape_no,
    :hives_cap,
    :particles_cap,
    :edge_id,
    :biotope_id,
    :algorithm_id,
    :scape_status,
    :scape_name,
    :biotope_name,
    :image_url,
    :theme,
    :tags,
    :algorithm_name,
    :algorithm_acronym,
    :hives
  ]

  @flat_fields [
    :scape_id,
    :scape_no,
    :hives_cap,
    :particles_cap,
    :edge_id,
    :biotope_id,
    :algorithm_id,
    :scape_status,
    :scape_name,
    :biotope_name,
    :image_url,
    :theme,
    :tags,
    :algorithm_name,
    :algorithm_acronym
  ]

  @required_fields [
    :scape_id,
    :scape_no,
    :hives_cap,
    :particles_cap,
    :edge_id,
    :biotope_id,
    :algorithm_id,
    :scape_status,
    :has_vacancy? 
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:scape_id, :string, default: "scp-#{UUID.uuid4()}")
    field(:scape_no, :integer)
    field(:hives_cap, :integer, default: 4)
    field(:particles_cap, :integer, default: 100)
    field(:edge_id, :string)
    field(:biotope_id, :binary_id)
    field(:algorithm_id, :binary_id)
    field(:scape_status, :integer, default: ScapeStatus.unknown())
    field(:has_vacancy?, :boolean, default: true)
    field(:scape_name, :string)
    field(:biotope_name, :string)
    field(:image_url, :string)
    field(:theme, :string)
    field(:tags, :string)
    field(:algorithm_name, :string)
    field(:algorithm_acronym, :string)
    embeds_one(:arena, ArenaInit, on_replace: :delete)
    embeds_many(:hives, HiveInit, on_replace: :delete)
  end

  def default,
    do: %ScapeInit{
      scape_id: "scape-#{UUID.uuid4()}",
      scape_no: 0,
      hives_cap: 4,
      particles_cap: 100,
      edge_id: "",
      biotope_id: UUID.uuid4(),
      algorithm_id: UUID.uuid4(),
      scape_status: ScapeStatus.unknown(),
      has_vacancy?: false,
      scape_name: "N/A",
      biotope_name: "N/A",
      image_url: "~p/images/scape_default.svg",
      theme: "N/A",
      tags: "",
      algorithm_name: "N/A",
      algorithm_acronym: "N/A",
      hives: []
    }

  def changeset(%ScapeInit{} = seed, %{} = args)
      when is_struct(args),
      do: changeset(seed, Map.from_struct(args))

  def changeset(%ScapeInit{} = seed, args)
      when is_map(args) do
    seed
    |> cast(args, @flat_fields)
    |> cast_embed(:hives, with: &HiveInit.changeset/2)
    |> validate_required(@required_fields)
    |> validate_hives_cap_must_be_greater_than_zero()
  end

  defp validate_hives_cap_must_be_greater_than_zero(changeset) do
    case get_field(changeset, :hives_cap) do
      nil -> changeset
      hives_cap when hives_cap > 0 -> changeset
      _ -> changeset |> add_error(:hives_cap, "must be greater than 0")
    end
  end

  def from_map(%ScapeInit{} = seed, map) do
    case(changeset(seed, map)) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        Logger.error("Failed to create Scape.Init: #{inspect(changeset)}")
        {:error, changeset}
    end
  end

  def display_name(%ScapeInit{scape_name: scape_name}) do
    scape_name
    |> String.replace("scape_", "")
    |> String.replace("-", " ")
    |> String.capitalize()
  end

  def new(scape_no, edge_init) do
    %ScapeInit{
      scape_id: "scape-#{UUID.uuid4()}",
      scape_no: scape_no,
      scape_name: NameUtils.random_name(2)
    }
    |> from_map(edge_init)
  end
end

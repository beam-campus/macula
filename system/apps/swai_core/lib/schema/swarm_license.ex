defmodule Schema.SwarmLicense do
  @moduledoc """
  The schema module for the swarm licenses.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Arena.Init, as: ArenaInit
  alias Edge.Init, as: EdgeInit
  alias Hive.Init, as: HiveInit
  alias Scape.Init, as: ScapeInit

  alias Swai.Defaults, as: Defaults

  @standard_cost_in_tokens Defaults.standard_cost_in_tokens()

  alias Schema.SwarmLicense, as: SwarmLicense
  alias Schema.SwarmLicense.Status, as: LicenseStatus

  @all_fields [
    :license_id,
    :status,
    :status_string,
    :user_id,
    :user_alias,
    :algorithm_id,
    :algorithm_name,
    :algorithm_acronym,
    :biotope_id,
    :biotope_name,
    :image_url,
    :theme,
    :tags,
    :swarm_name,
    :cost_in_tokens,
    :available_tokens,
    :reason,
    :additional_info,
    :scape_id,
    :scape_name,
    :edge_id,
    :hive_id,
    :hive_no
  ]

  @flat_fields [
    :license_id,
    :status,
    :status_string,
    :user_id,
    :user_alias,
    :algorithm_id,
    :algorithm_name,
    :algorithm_acronym,
    :biotope_id,
    :biotope_name,
    :image_url,
    :theme,
    :tags,
    :swarm_name,
    :cost_in_tokens,
    :available_tokens,
    :reason,
    :additional_info,
    :scape_id,
    :scape_name,
    :edge_id,
    :hive_id,
    :hive_no
  ]

  @required_fields [
    :license_id,
    :user_id,
    :user_alias,
    :biotope_id,
    :biotope_name,
    :algorithm_id,
    :algorithm_name,
    :algorithm_acronym
  ]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  schema "swarm_licenses" do
    field(:license_id, :binary_id, primary_key: true)

    field(:status, :integer, default: LicenseStatus.unknown())
    field(:status_string, :string, virtual: true)
    field(:user_id, :binary_id)
    field(:user_alias, :string, default: nil)

    field(:algorithm_id, :binary_id)
    field(:algorithm_name, :string)
    field(:algorithm_acronym, :string)

    field(:biotope_id, :binary_id)
    field(:biotope_name, :string)

    field(:image_url, :string)
    field(:theme, :string)
    field(:tags, :string)

    field(:swarm_name, :string,
      default: MnemonicSlugs.generate_slug(3) |> String.replace("-", "_")
    )

    field(:cost_in_tokens, :integer, default: @standard_cost_in_tokens)
    field(:available_tokens, :integer, default: 0)
    field(:reason, :string, default: nil)
    field(:additional_info, :string, default: nil)

    field(:scape_id, :string, default: nil)
    field(:scape_name, :string, default: nil)
    field(:edge_id, :string, default: nil)
    field(:hive_id, :string)
    field(:hive_no, :integer, default: 1)
    embeds_one(:scape, ScapeInit, on_replace: :delete)
    embeds_one(:edge, EdgeInit, on_replace: :delete)
    embeds_one(:hive, HiveInit, on_replace: :delete)
    embeds_one(:arena, ArenaInit, on_replace: :delete)
  end

  defp calculate_cost_in_tokens(changeset) do
    #    new_license =
    #  changeset
    #  |> apply_changes()

    new_cost = @standard_cost_in_tokens

    new_changeset =
      changeset
      |> put_change(:cost_in_tokens, new_cost)

    new_changeset
  end

  defp calculate_status_string(changeset) do
    new_training =
      changeset
      |> apply_changes()

    new_status_string =
      LicenseStatus.to_string(new_training.status)

    new_changeset =
      changeset
      |> put_change(:status_string, new_status_string)

    new_changeset
  end

  defp validate_swarm_name(changeset, _opts \\ []) do
    changeset
    |> validate_required([:swarm_name])
    |> validate_length(:swarm_name, min: 3, max: 50)
    |> validate_format(
      :swarm_name,
      ~r/^[a-zA-Z0-9_]+$/,
      message: "can only contain letters, numbers and underscores"
    )
    |> validate_format(
      :swarm_name,
      ~r/^\S+$/,
      message: "cannot be blank"
    )
  end

  def changeset(seed, map)
      when is_struct(map),
      do: changeset(seed, Map.from_struct(map))

  def changeset(seed, map)
      when is_map(map),
      do:
        seed
        |> cast(map, @flat_fields)
        |> validate_required(@required_fields)
        |> calculate_cost_in_tokens()
        |> validate_number(:cost_in_tokens, greater_than: -1)
        |> calculate_status_string()
        |> validate_swarm_name()

  def from_map(seed, nil),
    do: {:ok, seed}

  def from_map(seed, map)
      when is_struct(map),
      do: from_map(seed, Map.from_struct(map))

  def from_map(%SwarmLicense{license_id: license_id} = seed, %{license_id: nil} = map)
      when is_map(map) do
    map = Map.put(map, :license_id, license_id)
    from_map(seed, map)
  end

  def from_map(seed, map)
      when is_map(map) do
    case changeset(seed, map) do
      %{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end

  def new(user_id, biotope_id, biotope_name, algorithm_id, algorithm_name, algorithm_acronym),
    do: %SwarmLicense{
      license_id: UUID.uuid4(),
      user_id: user_id,
      biotope_id: biotope_id,
      biotope_name: biotope_name,
      algorithm_id: algorithm_id,
      algorithm_name: algorithm_name,
      algorithm_acronym: algorithm_acronym
    }
end

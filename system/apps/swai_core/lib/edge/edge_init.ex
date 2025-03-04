defmodule Edge.Init do
  use Ecto.Schema

  @moduledoc """
  Edge.Init is the struct that identifies the state of a Region.
  """
  alias AppUtils, as: AppUtils
  alias Edge.Init, as: EdgeInit
  alias Edge.Status, as: EdgeStatus
  alias Phoenix.Socket, as: Socket
  alias Schema.EdgeStats, as: Stats
  alias Apis.IpInfoCache, as: IpInfoCache
  alias Apis.Countries, as: Countries
  alias Swai.Defaults, as: Defaults

  import Ecto.Changeset

  require Logger
  require EnvVars

  @edge_status_unknown EdgeStatus.unknown()
  @scapes_cap Defaults.scapes_cap()

  @json_fields [
    :edge_id,
    :edge_status,
    :scapes_cap,
    :hives_cap,
    :particles_cap,
    :biotope_id,
    :biotope_name,
    :algorithm_acronym,
    :algorithm_id,
    :api_key,
    :is_container,
    :ip_address,
    :continent,
    :continent_code,
    :country,
    :country_code,
    :country_ccn3,
    :country_cca2,
    :country_cca3,
    :country_cioc,
    :region,
    :region_name,
    :city,
    :district,
    :zip,
    :lat,
    :lon,
    :timezone,
    :offset,
    :currency,
    :isp,
    :org,
    :as,
    :asname,
    :reverse,
    :mobile,
    :proxy,
    :hosting,
    :connected_since,
    :online_since,
    :image_url,
    :flag,
    :flag_svg,
    :stats
  ]

  @flat_fields [
    :edge_id,
    :edge_status,
    :scapes_cap,
    :hives_cap,
    :particles_cap,
    :biotope_id,
    :biotope_name,
    :algorithm_acronym,
    :algorithm_id,
    :api_key,
    :is_container,
    :ip_address,
    :continent,
    :continent_code,
    :country,
    :country_code,
    :country_ccn3,
    :country_cca2,
    :country_cca3,
    :country_cioc,
    :region,
    :region_name,
    :city,
    :district,
    :zip,
    :lat,
    :lon,
    :timezone,
    :offset,
    :currency,
    :isp,
    :org,
    :as,
    :asname,
    :reverse,
    :mobile,
    :proxy,
    :hosting,
    :connected_since,
    :online_since,
    :image_url,
    :flag,
    :flag_svg
  ]

  @required_fields [
    :edge_id,
    :edge_status,
    :biotope_id,
    :algorithm_acronym,
    :algorithm_id,
    :api_key,
    :is_container,
    :connected_since,
    :online_since
  ]

  @derive {Jason.Encoder, only: @json_fields}
  @primary_key false
  embedded_schema do
    field(:edge_id, :string)
    field(:edge_status, :integer, default: @edge_status_unknown)
    field(:scapes_cap, :integer, default: 1)
    field(:hives_cap, :integer, default: 2)
    field(:particles_cap, :integer)
    field(:biotope_id, :binary_id)
    field(:biotope_name, :string)
    field(:algorithm_acronym, :string)
    field(:algorithm_id, :binary_id)
    field(:api_key, :string)
    field(:is_container, :boolean, default: false)
    field(:ip_address, :string)
    field(:continent, :string)
    field(:continent_code, :string)
    field(:country, :string)
    field(:country_code, :string)
    field(:country_ccn3, :string)
    field(:country_cca2, :string)
    field(:country_cca3, :string)
    field(:country_cioc, :string)
    field(:region, :string)
    field(:region_name, :string)
    field(:city, :string)
    field(:district, :string)
    field(:zip, :string)
    field(:lat, :float)
    field(:lon, :float)
    field(:timezone, :string)
    field(:offset, :integer)
    field(:currency, :string)
    field(:isp, :string)
    field(:org, :string)
    field(:as, :string)
    field(:asname, :string)
    field(:reverse, :string)
    field(:mobile, :boolean)
    field(:proxy, :boolean)
    field(:hosting, :boolean)
    field(:connected_since, :utc_datetime)
    field(:online_since, :utc_datetime)
    field(:image_url, :string, default: "https://picsum.photos/400/300")
    field(:flag, :string, default: "\u127988")
    field(:flag_svg, :string, default: "https://picsum.photos/400/300")
    embeds_one(:stats, Stats, on_replace: :delete)
    embeds_one(:socket, Socket, on_replace: :delete)
  end

  def changeset(seed, struct)
      when is_struct(struct),
      do: changeset(seed, Map.from_struct(struct))

  def changeset(edge, args)
      when is_map(args),
      do:
        edge
        |> cast(args, @flat_fields)
        |> cast_embed(:stats, with: &Stats.changeset/2)
        |> validate_required(@required_fields)

  def from_map(seed, map) do
    case(changeset(seed, map)) do
      %{valid?: true} = changeset ->
        edge_init =
          changeset
          |> Ecto.Changeset.apply_changes()

        {:ok, edge_init}

      changeset ->
        {:error, changeset}
    end
  end

  def default,
    do: %EdgeInit{
      edge_id: "N/A",
      edge_status: EdgeStatus.unknown(),
      biotope_id: "N/A",
      algorithm_acronym: "N/A",
      api_key: "N/A",
      is_container: false,
      ip_address: "N/A",
      continent: "N/A",
      continent_code: "N/A",
      country: "N/A",
      country_code: "N/A",
      country_ccn3: "N/A",
      country_cca2: "N/A",
      country_cca3: "N/A",
      country_cioc: "N/A",
      region: "N/A",
      region_name: "N/A",
      city: "N/A",
      district: "N/A",
      zip: "N/A",
      lat: 0.0,
      lon: 0.0,
      timezone: "N/A",
      offset: 0,
      currency: "N/A",
      isp: "N/A",
      org: "N/A",
      as: "N/A",
      asname: "N/A",
      reverse: "N/A",
      mobile: false,
      proxy: false,
      hosting: false,
      connected_since: DateTime.utc_now(),
      online_since: DateTime.utc_now(),
      image_url: "https://picsum.photos/400/300",
      flag: "\u127988",
      flag_svg: "https://picsum.photos/400/300",
      stats: Stats.empty()
    }

  def from_environment do
    {:ok, chost} = :inet.gethostname()
    edge_id = "e-#{to_string(chost)}-#{inspect(UUID.uuid4())}"

    api_key = System.get_env(EnvVars.swai_edge_api_key(), "no-api-key")

    biotope_id = System.get_env(EnvVars.swai_edge_biotope_id(), "no-biotope-id-configured")

    %EdgeInit{
      edge_id: edge_id,
      edge_status: @edge_status_unknown,
      api_key: api_key,
      is_container: AppUtils.running_in_container?(),
      ip_address: "unknown",
      biotope_id: biotope_id,
      continent: "unknown",
      continent_code: "unknown",
      country: "unknown",
      country_code: "unknown",
      country_ccn3: "000",
      region: "unknown",
      region_name: "unknown",
      city: "unknown",
      zip: "unknown",
      lat: 0.0,
      lon: 0.0,
      timezone: "unknown",
      offset: 0,
      currency: "unknown",
      isp: "unknown",
      org: "unknown",
      as: "unknown",
      asname: "unknown",
      reverse: "unknown",
      mobile: false,
      proxy: false,
      hosting: false,
      connected_since: DateTime.utc_now(),
      online_since: DateTime.utc_now(),
      image_url: "https://picsum.photos/400/300",
      flag: "\u127988",
      flag_svg: "https://picsum.photos/400/300",
      stats: Stats.empty()
    }
  end

  defp do_get_cca2_and_flag_svg(country_info) do
    case System.get_env(EnvVars.swai_edge_cca2()) do
      nil ->
        [country_info["cca2"], country_info["flags"]["svg"]]

      cca2 ->
        [cca2, "https://flagcdn.com/#{String.downcase(cca2)}.svg"]
    end
  end

  def from_environment(ip_info, country_info \\ %{}) when is_map(ip_info) do
    {:ok, chost} = :inet.gethostname()
    api_key = System.get_env(EnvVars.swai_edge_api_key()) || "no-api-key"
    biotope_id = System.get_env(EnvVars.swai_edge_biotope_id()) || "no-biotope-id"

    algorithm_acronym =
      System.get_env(EnvVars.swai_edge_algorithm_acronym()) || "no-algorithm-acronym"

    latitude = EnvVars.get_env_var_as_float(EnvVars.swai_edge_lat(), ip_info["lat"])
    longitude = EnvVars.get_env_var_as_float(EnvVars.swai_edge_lon(), ip_info["lon"])

    country = System.get_env(EnvVars.swai_edge_country()) || ip_info["country"]
    country_code = System.get_env(EnvVars.swai_edge_country_code()) || ip_info["countryCode"]
    city = System.get_env(EnvVars.swai_edge_city()) || ip_info["city"]
    scapes_cap = EnvVars.get_env_var_as_integer(EnvVars.swai_edge_scapes_cap(), @scapes_cap)

    [country_cca2, flag_svg] =
      do_get_cca2_and_flag_svg(country_info)

    is_container =
      EnvVars.get_env_var_as_boolean(
        EnvVars.swai_edge_is_container(),
        AppUtils.running_in_container?()
      )

    edge_id = "#{to_string(chost)}-" <> api_key

    %EdgeInit{
      edge_id: edge_id,
      scapes_cap: scapes_cap,
      edge_status: @edge_status_unknown,
      biotope_id: biotope_id,
      algorithm_acronym: algorithm_acronym,
      api_key: api_key,
      is_container: is_container,
      ip_address: ip_info["query"],
      continent: ip_info["continent"],
      continent_code: ip_info["continentCode"],
      country: country,
      country_code: country_code,
      country_ccn3: country_info["ccn3"],
      country_cca2: country_cca2,
      country_cca3: country_info["cca3"],
      country_cioc: country_info["cioc"],
      region: ip_info["region"],
      region_name: ip_info["regionName"],
      city: city,
      zip: ip_info["zip"],
      lat: latitude,
      lon: longitude,
      timezone: ip_info["timezone"],
      offset: ip_info["offset"],
      currency: ip_info["currency"],
      isp: ip_info["isp"],
      org: ip_info["org"],
      as: ip_info["as"],
      asname: ip_info["asname"],
      reverse: ip_info["reverse"],
      mobile: ip_info["mobile"],
      proxy: ip_info["proxy"],
      hosting: ip_info["hosting"],
      connected_since: DateTime.utc_now(),
      online_since: DateTime.utc_now(),
      image_url: "https://picsum.photos/400/300",
      flag: "\u127988",
      flag_svg: flag_svg,
      stats: Stats.empty()
    }
  end

  def enriched do
    {:ok, ip_info} =
      IpInfoCache.refresh()

    country_info =
      case Countries.get_country_by_country_code(ip_info["countryCode"]) do
        {:ok, country} -> country
        _ -> %{}
      end

    new_info =
      ip_info
      |> Map.put("flag_svg", country_info["flags"]["svg"])

    Logger.info("IP Info: #{inspect(new_info)}")

    from_environment(new_info, country_info)
  end
end

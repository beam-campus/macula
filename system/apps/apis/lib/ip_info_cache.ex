defmodule Apis.IpInfoCache do
  @moduledoc """
  The Cache module is used to store and retrieve data from the IpInfo API.
  """

  @api_info_url "http://ip-api.com/json/?fields=status,message,continent,continentCode,country,countryCode,region,regionName,city,district,zip,lat,lon,timezone,offset,currency,isp,org,as,asname,reverse,mobile,proxy,hosting,query"

  def refresh(),
    do: {:ok, Req.get!(@api_info_url).body()}

  # ################### CALLBACKS ###################
  # def init(_args) do
  #   {:ok, get_ipinfo()}
  # end

  # ################### PLUMBING ####################

  # def child_spec(),
  # do:
  #   %{
  #     id: __MODULE__,
  #     start: {__MODULE__, :start_link, []},
  #     type: :worker,
  #     restart: :permanent
  #   }

  # def start_link(),
  # do:
  #   GenServer.start_link(
  #     __MODULE__,
  #     [],
  #     name: __MODULE__)
end

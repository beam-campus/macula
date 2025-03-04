defmodule NordVpnCache do
  use GenServer

  @moduledoc """
  The NordvpnCache is used to cache the nordvpn data
  """

  require Logger
  require Req
  require Cachex

  @nordvpn_api_url "https://api.nordvpn.com/v1/servers"

  ############# API ################
  def get_overview(country \\ ""),
    do:
      GenServer.call(
        __MODULE__,
        {:get_overview, country}
      )

  ############### CALLBACKS ###############
  @impl GenServer
  def handle_call({:get_overview, _country}, _from, state) do
    overview =
      state
      |> Enum.map(fn server ->
        %{
          name: server["name"],
          hostname: server["hostname"],
          technologies:
            server["technologies"]
            |> Enum.filter(fn tech ->
              tech["name"] == "Wireguard"
            end)
            |> Enum.flat_map(fn tech ->
              %{
                name: tech["name"],
                public_key:
                  tech["metadata"]
                  # |> Enum.map(& %{public_key: &1["value"]  })
                  |> Enum.map(& &1["value"])
                  |> List.first()
              }
            end)
        }
      end)
      |> Enum.filter(&(&1.technologies |> Enum.any?()))
      |> Enum.map(
        &%{
          name: &1.name,
          hostname: &1.hostname,
          public_key: &1.technologies |> Keyword.get(:public_key)
        }
      )

    # |> Enum.filter(
    #   &%{
    #     hostname: &1.hostname,
    #     public_key: &1.technologies |> Enum.map(fn tech -> tech |> Keyword.get("public_key") end)
    #   }
    # )

    # |> Enum.map(fn server ->
    #   %{
    #     hostname: server.hostname,
    #     public_keys:
    #       server.technologies
    #       |> Enum.map(fn tech ->
    #         tech.meta_data
    #       end)
    #       |> List.flatten()
    #   }
    # end)

    # |> Enum.flat_map_reduce(& &1.technologies |> Enum.flat_map() )
    # |> Enum.map(fn server ->
    #   %{
    #     locations: server["locations"],
    #     id: server["id"],
    #     name: server["name"],
    #     hostname: server["hostname"],
    #     load: server["load"],
    #     status: server["status"],
    #     tech_names: server["technologies"] |> Enum.map(& &1["name"])
    #   }
    # end)
    # |> Enum.filter(&String.contains?(&1.name, country))

    {:reply, overview, state}
  end

  @impl GenServer
  def init(_args) do
    state = Req.get!(@nordvpn_api_url).body()
    {:ok, state}
  end

  ################# PLUMBING ####################
  def child_spec(),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent
    }

  def start_link(args),
    do:
      GenServer.start_link(
        __MODULE__,
        args,
        name: __MODULE__
      )
end

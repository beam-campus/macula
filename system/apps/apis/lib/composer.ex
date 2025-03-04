defmodule Composer do
  use GenServer

  @moduledoc """
  The Composer is used to compose the data from the APIs
  """
  require Logger
  require NordVpnCache

  ############# API ################

  def write_compose_files(path \\ "../../../../swai_deploy"),
    do:
      GenServer.cast(
        __MODULE__,
        {:write_compose_files, path}
      )

  ############### CALLBACKS ###############

  @impl GenServer
  def init(_init_arg \\ []) do
    Supervisor.start_link(
      [
        NordVpnCache
      ],
      strategy: :one_for_one,
      name: :nord_vpn_cache_sup
    )

    nord_vpn_overview = NordVpnCache.get_overview()
    {:ok, nord_vpn_overview}
  end

  @impl GenServer
  def handle_cast({:write_compose_files, path}, state) do
    path = Path.expand(path)
    path = Path.absname(path)
    Logger.info("Writing compose files to [#{path}]")
    host_port = 4000

    files_written =
      state
      |> Enum.with_index()
      |> Enum.map(fn {entry, index} ->
        host_port = host_port + index

        name =
          entry.name
          |> String.replace("#", "")
          |> String.replace(" ", "_")
          |> String.downcase()

        [suffix | _rest] = String.split(entry.hostname, ".")

        content = "
        version: '3.7'

        networks:
          #{suffix}_net:
            driver: bridge
            name: #{suffix}_net



        services:

          nordlynx_#{suffix}:
            image: ghcr.io/bubuntux/nordlynx
            container_name: #{name}_#{suffix}
            cap_add:
              - NET_ADMIN                             # required
              - SYS_MODULE                            # maybe
            ports:
              - 51820:51820/udp
              - #{host_port}:4000/tcp
            networks:
              - #{suffix}_net
            environment:
              - PUBLIC_KEY=#{entry.public_key}
              - PRIVATE_KEY=$NETLYNX_PRIVATE_KEY               # required
              - END_POINT=#{entry.hostname}
              - NET_LOCAL=192.168.0.0/16
            restart: always
            sysctls:
              - net.ipv4.conf.all.rp_filter=2
              - net.ipv4.conf.default.rp_filter=2
              - net.ipv4.conf.eth0.rp_filter=2
              - net.ipv4.conf.all.src_valid_mark=1   # maybe
              - net.ipv6.conf.all.disable_ipv6=1     # disable ipv6; recommended if using ipv4 only

          edge_#{suffix}:
            image: beamcampus/swai_edge:latest
            container_name: edge_#{suffix}
            network_mode: service:nordlynx_#{suffix}
            depends_on:
              - nordlynx_#{suffix}
            restart: always
            environment:
              - SWAI_EDGE_API_KEY=${SWAI_EDGE_API_KEY}
              - PUID=1000
              - PGID=1000
            security_opt:
              - seccomp:unconfined

        "
        file_name = "del_#{suffix}.yml"
        File.write!(Path.join(path, file_name), content)

        {file_name}
      end)

    inspect(files_written)
    # Logger.info("\n\n Files written: \n #{} \n\n")
    {:noreply, state}
  end

  ################# PLUMBING ################
  def start_link(),
    do:
      GenServer.start_link(
        __MODULE__,
        [],
        name: __MODULE__
      )
end

defmodule Hive.Emitter do
  @moduledoc """
  This module is responsible for emitting events to the edge.
  """
  alias Edge.Client, as: Client
  alias Hive.Facts, as: HiveFacts
  alias Hive.Hopes, as: HiveHopes
  alias Hive.Init, as: HiveInit
  alias Schema.SwarmLicense, as: License

  require Logger

  @reserve_license_v1 HiveHopes.reserve_license_v1()
  @hive_initialized_v1 HiveFacts.hive_initialized_v1()
  @hive_occupied_v1 HiveFacts.hive_occupied_v1()
  @hive_vacated_v1 HiveFacts.hive_vacated_v1()
  @hive_detached_v1 HiveFacts.hive_detached_v1()

  def do_deserialize_license_map!(license_map) do
    case License.from_map(%License{}, license_map) do
      {:ok, license} ->
        license

      {:error, changeset} ->
        Logger.error("invalid LICENSE input map, reason: #{inspect(changeset)}")
        raise "invalid LICENSE input map, reason: #{inspect(changeset)}"
    end
  end

  def try_reserve_license(%HiveInit{edge_id: edge_id} = hive_init) do
    case Client.request(
           edge_id,
           @reserve_license_v1,
           %{hive_init: hive_init}
         ) do
      {:ok, nil} ->
        nil

      {:ok, license_map} ->
        do_deserialize_license_map!(license_map)
    end
  end

  def emit_hive_detached(%HiveInit{edge_id: edge_id} = hive) do
    Client.publish(
      edge_id,
      @hive_detached_v1,
      %{hive_init: hive}
    )
  end

  def emit_hive_initialized(%HiveInit{edge_id: edge_id} = hive_init),
    do:
      Client.publish(
        edge_id,
        @hive_initialized_v1,
        %{hive_init: hive_init}
      )

  def emit_hive_occupied(%HiveInit{edge_id: edge_id} = hive) do
    Client.publish(
      edge_id,
      @hive_occupied_v1,
      %{hive_init: hive}
    )
  end

  def emit_hive_vacated(%HiveInit{edge_id: edge_id} = hive_init),
    do:
      Client.publish(
        edge_id,
        @hive_vacated_v1,
        %{hive_init: hive_init}
      )
end

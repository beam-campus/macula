defmodule SwaiWeb.HiveDispatcher do
  @moduledoc false
  alias Commanded.PubSub

  require Logger
  require Phoenix.PubSub, as: PubSub

  alias Hive.Facts, as: HiveFacts
  alias Hive.Init, as: HiveInit
  alias Hives.Service, as: Hives
  alias Licenses.Service, as: Licenses

  alias Schema.SwarmLicense, as: License
  alias Swai.PubSub, as: SwaiPubSub

  alias TrainSwarmProc.CommandedApp, as: ProcApp
  alias TrainSwarmProc.ReserveLicense.CmdV1, as: ReserveLicense
  alias TrainSwarmProc.StartLicense.CmdV1, as: StartLicense

  @hive_facts HiveFacts.hive_facts()
  @hive_initialized_v1 HiveFacts.hive_initialized_v1()
  @hive_occupied_v1 HiveFacts.hive_occupied_v1()
  @hive_vacated_v1 HiveFacts.hive_vacated_v1()
  @hive_detached_v1 HiveFacts.hive_detached_v1()

  def do_detach_hive(%HiveInit{} = hive_init) do
    Logger.warning("Detaching hive: #{inspect(hive_init)}")

    SwaiPubSub
    |> PubSub.broadcast!(@hive_facts, {@hive_detached_v1, hive_init})
  end

  def detach_edge(edge_id) do
    Hives.get_all()
    |> Enum.filter(fn hive -> hive.edge_id == edge_id end)
    |> Enum.each(fn hive ->
      do_detach_hive(hive)
    end)
  end

  def detach_scape(%{scape_id: scape_id}) do
    Hives.get_all()
    |> Enum.filter(fn hive -> hive.scape_id == scape_id end)
    |> Enum.each(fn hive ->
      do_detach_hive(hive)
    end)
  end

  # defp do_decorate_license(%License{} = license, %HiveInit{} = hive_init) do
  #   case License.from_map(license, hive_init) do
  #     {:ok, license} ->
  #       license
  #
  #     {:error, changeset} ->
  #       Logger.error("invalid HIVE input map, reason: #{inspect(changeset)}")
  #       nil
  #   end
  # end

  defp do_reserve_license(%{license_id: agg_id} = claimed_license) do
    reserve_license = %ReserveLicense{
      agg_id: agg_id,
      version: 1,
      payload: claimed_license
    }

    ProcApp.dispatch(reserve_license)
  end

  defp do_try_claim_license(hive_init) do
    case Licenses.claim_license(hive_init) do
      nil ->
        nil

      claimed_license ->
        do_reserve_license(claimed_license)
        claimed_license
    end
  end

  ## Reserve a license for a hive
  def try_reserve_license(%{"hive_init" => hive_map}) do
    case HiveInit.from_map(%HiveInit{}, hive_map) do
      {:ok, hive_init} ->
        do_try_claim_license(hive_init)

      {:error, changeset} ->
        Logger.error("invalid envelope, reason: #{inspect(changeset)}")
        nil
    end
  end

  def pub_hive_detached(envelope) do
    case HiveInit.from_map(%HiveInit{}, envelope["hive_init"]) do
      {:ok, hive_init} ->
        SwaiPubSub
        |> PubSub.broadcast!(@hive_facts, {@hive_detached_v1, hive_init})

      {:error, changeset} ->
        Logger.error("invalid envelope, reason: #{inspect(changeset)}")
        {:error, "invalid hive_init"}
    end
  end

  ######## HIVE INITIALIZED ########
  def pub_hive_initialized(envelope) do
    case HiveInit.from_map(%HiveInit{}, envelope["hive_init"]) do
      {:ok, hive_init} ->
        SwaiPubSub
        |> PubSub.broadcast!(@hive_facts, {@hive_initialized_v1, hive_init})

      {:error, changeset} ->
        Logger.error("invalid envelope, reason: #{inspect(changeset)}")
        {:error, "invalid hive_init"}
    end
  end

  defp do_start_license_on_hive(
         %HiveInit{
           hive_id: hive_id,
           license_id: license_id,
           user_alias: user_alias,
           license: license
         } = hive
       ) do
    Logger.warning("
      Starting license [#{license_id}] 
      for user \"#{user_alias}\" 
      on hive: #{hive_id}    
      #{inspect(license)}
      ")

    start_info =
      case License.from_map(license, hive) do
        {:ok, license} ->
          license

        {:error, changeset} ->
          Logger.error("invalid HIVE input map, reason: #{inspect(changeset)}")
          nil
      end

    start_license = %StartLicense{
      agg_id: license_id,
      version: 1,
      payload: start_info
    }

    ProcApp.dispatch(start_license)
  end

  ######## HIVE OCCUPIED ########
  def pub_hive_occupied(%{"hive_init" => hive_map}) do
    case HiveInit.from_map(%HiveInit{}, hive_map) do
      {:ok, hive_init} ->
        start_license =
          Task.async(fn ->
            do_start_license_on_hive(hive_init)
          end)

        SwaiPubSub
        |> PubSub.broadcast!(@hive_facts, {@hive_occupied_v1, hive_init})

        Task.await(start_license)

      {:error, changeset} ->
        Logger.error("invalid HIVE_INIT envelope, reason: #{inspect(changeset)}")
        {:error, changeset}
    end
  end

  ######## HIVE VACATED ########
  def pub_hive_vacated(envelope) do
    case HiveInit.from_map(%HiveInit{}, envelope["hive_init"]) do
      {:ok, hive_init} ->
        SwaiPubSub
        |> PubSub.broadcast!(@hive_facts, {@hive_vacated_v1, hive_init})

      {:error, changeset} ->
        Logger.error("invalid envelope, reason: #{inspect(changeset)}")
        {:error, changeset}
    end
  end
end

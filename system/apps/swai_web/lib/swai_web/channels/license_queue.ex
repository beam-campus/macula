defmodule SwaiWeb.LicenseQueue do
  @moduledoc """
  The LicenseQueue is used to broadcast messages to all clients
  """
  use GenServer

  require Logger

  require Logger
  require Colors

  def start(init_args) do
    case start_link(init_args) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
      {:error, reason} -> {:error, reason}
    end
  end

  ### INIT ##########################
  @impl true
  def init(_init_args \\ []) do
    Logger.debug("LicenseQueue is up: #{Colors.server_theme(self())}")

    {:ok, []}
  end

  #### SUBSCRIPTIONS FALLTHROUGH ##################
  @impl true
  def handle_info(_, state) do
    {:noreply, state}
  end

  #################### PLUMBING ###################
  def start_link(init_args) do
    GenServer.start_link(
      __MODULE__,
      init_args,
      name: __MODULE__
    )
  end

  def child_spec(init_args),
    do: %{
      id: __MODULE__,
      start: {
        __MODULE__,
        :start,
        [init_args]
      },
      type: :worker
    }

  def via(key),
    do: Swai.Registry.via_tuple({:scape_queue, to_name(key)})

  def via_sup(key),
    do: Swai.Registry.via_tuple({:scape_queue_sup, to_name(key)})

  def to_name(key) when is_bitstring(key),
    do: "license.queue.#{key}"
end

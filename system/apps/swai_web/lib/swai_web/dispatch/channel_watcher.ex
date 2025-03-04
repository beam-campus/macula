defmodule SwaiWeb.Dispatch.ChannelWatcher do
  use GenServer

  @moduledoc """
  The ChannelWatcher is used to monitor channels
  """

  ##################### API #####################

  def monitor(server_name, pid, mfa),
    do:
      GenServer.call(
        via(server_name),
        {:monitor, pid, mfa}
      )

  def demonitor(server_name, pid),
    do:
      GenServer.call(
        via(server_name),
        {:demonitor, pid}
      )

  ################ CALLBACKS ################
  def handle_call({:monitor, pid, mfa}, _from, state) do
    Process.link(pid)
    {:reply, :ok, put_channel(state, pid, mfa)}
  end

  def handle_call({:demonitor, pid}, _from, state) do
    case Map.fetch(state.channels, pid) do
      :error ->
        {:reply, :ok, state}

      {:ok, _mfa} ->
        Process.unlink(pid)
        {:reply, :ok, drop_channel(state, pid)}
    end
  end

  def handle_info({:EXIT, pid, _reason}, state) do
    case(Map.fetch(state.channels, pid)) do
      :error ->
        {:noreply, state}

      {:ok, {mod, func, args}} ->
        Task.start_link(fn -> apply(mod, func, args) end)
        {:noreply, drop_channel(state, pid)}
    end
  end

  ############### INTERNALS ###################
  defp drop_channel(state, pid),
    do: %{state | channels: Map.delete(state.channels, pid)}

  defp put_channel(state, pid, mfa),
    do: %{state | channels: Map.put(state.channels, pid, mfa)}

  ############### PLUMBING ###################
  def to_name(key) when is_bitstring(key),
    do: "channel_watcher.#{key}"

  def via(key),
    do: Swai.Registry.via_tuple({:edge_channel_watcher, to_name(key)})

  def start_link(name),
    do:
      GenServer.start_link(
        __MODULE__,
        [],
        name: via(name)
      )

  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{channels: Map.new()}}
  end
end

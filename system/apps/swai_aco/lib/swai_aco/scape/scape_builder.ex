defmodule Scape.Builder do
  @moduledoc """
  This module is responsible for managing the scape builder.
  """
  use GenServer
  alias Swai.Registry, as: SwaiRegistry
  alias Scape.Init, as: ScapeInit
  alias Scape.System, as: ScapeSystem

  require Logger
  require Colors


  ###################### INIT ####################
  @impl true
  def init(%ScapeInit{} = scape_init) do
    Process.flag(:trap_exit, true)


    Logger.debug("scape.builder is up: #{Colors.scape_theme(self())} id: #{scape_init.id}")
    {:ok, scape_init}
  end




  ################### PLUMBING ###################
  def to_name(scape_id),
    do: "scape.builder.#{scape_id}"

  def via(key),
    do: SwaiRegistry.via_tuple({:scape_builder, to_name(key)})

  def via_sup(key),
    do: SwaiRegistry.via_tuple({:scape_sup, to_name(key)})

  def child_spec(%ScapeInit{scape_id: scape_id} = scape_init) do
    %{
      id: to_name(scape_id),
      start: {__MODULE__, :start_link, [scape_init]},
      type: :supervisor,
      restart: :transient
    }
  end

  def start_link(%ScapeInit{} = scape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        scape_init,
        name: via(scape_init.id)
      )
end

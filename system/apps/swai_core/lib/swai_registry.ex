defmodule Swai.Registry do
  @moduledoc """
  Swai.Registry is a simple key-value store that allows processes to be registered
  """
  ############ INTERFACE ###########
  def unregister(key),
    do: Registry.unregister(__MODULE__, key)

  def register(key, pid),
    do: Registry.register(__MODULE__, key, pid)

  def lookup(key),
    do: Registry.lookup(__MODULE__, key)

  def via_tuple(key),
    do: {:via, Registry, {__MODULE__, key}}

  ############# PLUMBING ############
  def start_link,
    do:
      Registry.start_link(
        keys: :unique,
        name: __MODULE__
      )

  def child_spec(_),
    do:
      Supervisor.child_spec(
        Registry,
        id: __MODULE__,
        start: {__MODULE__, :start_link, []}
      )
end

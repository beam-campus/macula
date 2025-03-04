defmodule Arena.Status do
  @moduledoc """
  Arena.Status contains the string literals for Arena Events.
  These events will be used both at the edge as well as in PubSub.
  """

  def unknown, do: 0
  def arena_initialized, do: 1

end

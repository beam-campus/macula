defmodule Arena.Facts do
  @moduledoc """
  Arena.Facts contains the string literals for Arena Events.
  These events will be used both at the edge as well as in PubSub.
  """
  def arena_facts, do: "arena_facts"
  def arena_terminated_v1, do: "arena_terminated:v1"
  def arena_initialized_v1, do: "arena_initialized:v1"

  def arenas_cache_facts, do: "arenas_cache_facts"
end

defmodule Hive.Facts do
  @moduledoc """
  Hive.Facts is the struct that identifies the facts of a Region.
  """
  def hive_facts, do: "hive_facts"

  def hive_initialized_v1, do: "hive_initialized:v1"
  def hive_occupied_v1, do: "hive_occupied:v1"
  def hive_vacated_v1, do: "hive_vacated:v1"
  def hive_arena_initialized_v1, do: "hive_arena_initialized:v1"
  def hive_detached_v1, do: "hive_detached:v1"

  def hives_cache_facts, do: "hives_cache_facts"
end

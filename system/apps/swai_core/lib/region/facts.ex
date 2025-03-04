defmodule Region.Facts do
  @moduledoc """
  Region.Facts contains the facts for the Region subsystem.
  """

  def initializing_region_v1,
    do: "initializing_region_v1"

  def region_initialized_v1,
    do: "region_initialized_v1"

  def region_detached_v1,
    do: "region_detached_v1"

  def regions_cache_updated_v1,
    do: "regions_cache_updated_v1"
end

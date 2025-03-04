defmodule Scape.Utils do
  @moduledoc """
  ScapeUtils contains utility functions for the Scape subsystem.
  """
  alias Schema.Vector, as: Vector
  alias Arena.Hexa, as: Hexa
  alias Swai.Defaults, as: Defaults

  require Logger

  @width Defaults.arena_width()
  @height Defaults.arena_height()
  @offset Defaults.arena_hive_offset()
  @hexa_size Defaults.arena_hexa_size()

  def get_hive_location(1), do: %Vector{x: @offset, y: @offset, z: 0}
  def get_hive_location(2), do: %Vector{x: @width - @offset, y: @offset, z: 0}
  def get_hive_location(3), do: %Vector{x: @width - @offset, y: @height - @offset, z: 0}
  def get_hive_location(4), do: %Vector{x: @offset, y: @height - @offset, z: 0}
  def get_hive_location(5), do: %Vector{x: round(@width / 2), y: @offset, z: 0}
  def get_hive_location(6), do: %Vector{x: round(@width / 2), y: @height - @offset, z: 0}
  def get_hive_location(_), do: raise("Invalid hive number....must be between 1 and 6")

  def get_hive_hexa(n) do
    map = Hexa.cartesian_to_axial(get_hive_location(n), @hexa_size)
    {:ok, hexa} = Hexa.from_map(%Hexa{}, map)
    hexa
  end

  def get_hive_orientation(n) do
    case n do
      1 -> "SE"
      2 -> "SW"
      3 -> "NW"
      4 -> "NE"
      5 -> "S"
      6 -> "N"
      _ -> raise("Invalid hive number....must be between 1 and 6")
    end
  end
end

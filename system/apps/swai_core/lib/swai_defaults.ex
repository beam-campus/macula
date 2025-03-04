defmodule Swai.Defaults do
  @moduledoc """
  Swai.Defaults contains the default values for the Swai system.
  """
  alias Schema.Vector, as: Vector

  def standard_cost_in_tokens, do: 3_000
  def arena_width, do: 800
  def arena_height, do: 600
  def arena_depth, do: 0
  def arena_hive_offset, do: 50
  def arena_hexa_size, do: 5
  def arena_maze_density, do: 100
  def hives_cap, do: 4
  def scapes_cap, do: 2
  def particles_cap, do: 50
  def threats_cap, do: 10
  def collectibles_cap, do: 10
  def hive_cycle, do: 1_000
  def initial_claim_delay, do: 30_000
  def normal_claim_delay, do: 10_000
  def start_swarm_delay, do: 10_000
  def move_every, do: 500

  
  def particle_heartbeat, do: 1_000
  ## 1 minute
  def particle_heartbeats_per_age, do: 60
  ## 15 minutes
  def particle_max_age, do: 5

  def arena_dimensions, do: Vector.new(arena_width(), arena_height(), arena_depth())

  def hive_colors,
    do: %{
      1 => "blue",
      2 => "red",
      3 => "green",
      4 => "orange",
      5 => "yellow",
      6 => "indigo"
    }

  def directions,
    do: %{
      "N" => Vector.new(0, -1, 0),
      "NE" => Vector.new(1, -1, 0),
      "E" => Vector.new(1, 0, 0),
      "SE" => Vector.new(1, 1, 0),
      "S" => Vector.new(0, 1, 0),
      "SW" => Vector.new(-1, 1, 0),
      "W" => Vector.new(-1, 0, 0),
      "NW" => Vector.new(-1, -1, 0)
    }

  def hexa_directions,
    do: %{
      "W" => {-1, 0},
      "NW" => {-1, -1},
      "NE" => {1, -1},
      "E" => {1, 0},
      "SE" => {1, 1},
      "SW" => {-1, 1},
      "N" => {0, -1},
      "S" => {0, 1},
      "O" => {0, 0}
    }

  def hexa_reverse_directions,
    do: %{
      {-1, 0} => "W",
      {-1, -1} => "NW",
      {1, -1} => "NE",
      {1, 0} => "E",
      {1, 1} => "SE",
      {-1, 1} => "SW",
      {0, -1} => "N",
      {0, 1} => "S",
      {0, 0} => "O"
    }

  def hexa_bounce_delta(:horizontal_wall),
    do: %{
      "N" => {0, 0},
      "S" => {0, 0},
      "E" => {0, 0},
      "W" => {0, 0},
      "NW" => {-2, 0},
      "NE" => {2, 0},
      "SW" => {-2, 0},
      "SE" => {2, 0}
    }

  def hexa_bounce_delta(:vertical_wall),
    do: %{
      "N" => {0, 0},
      "S" => {0, 0},
      "E" => {0, 0},
      "W" => {0, 0},
      "NW" => {-2, 0},
      "NE" => {2, 0},
      "SW" => {2, 0},
      "SE" => {0, 2}
    }

  def bounce_directions(:vertical_wal),
    do: %{
      "NW" => "SW",
      "SW" => "NW",
      "NE" => "SE",
      "SE" => "NE",
      "N" => "N",
      "S" => "S",
      "E" => "W",
      "W" => "E"
    }

  def bounce_directions(:horizontal_wall),
    do: %{
      "NW" => "NE",
      "NE" => "NW",
      "SW" => "SE",
      "SE" => "SW",
      "N" => "S",
      "S" => "N",
      "E" => "E",
      "W" => "W"
    }

  def bounce_directions(:no_wall),
    do: %{
      "NW" => "NW",
      "NE" => "NE",
      "SW" => "SW",
      "SE" => "SE",
      "N" => "N",
      "S" => "S",
      "E" => "E",
      "W" => "W"
    }
end

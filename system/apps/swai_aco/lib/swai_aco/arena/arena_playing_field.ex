defmodule Arena.PlayingField do
  @moduledoc """
  A module to represent a game arena with hives and walls,
  and generate an SVG representation.
  """

  defstruct width: 0, height: 0, hives: [], walls: []

  @type point :: {integer, integer}
  @type t :: %__MODULE__{
          width: integer,
          height: integer,
          hives: [point],
          walls: [point]
        }

  @doc """
  Creates a new game arena with the specified dimensions.
  """
  def new(width, height, hives \\ [], walls \\ []) do
    %__MODULE__{
      width: width,
      height: height,
      hives: hives,
      walls: walls
    }
  end

  @doc """
  Generates an SVG representation of the game arena.
  """
  def to_svg(%__MODULE__{width: width, height: height, hives: hives, walls: walls}) do
    """
    <svg width="#{width}" height="#{height}" xmlns="http://www.w3.org/2000/svg">
      #{Enum.map_join(hives, "\n", fn {x, y} -> hive_svg(x, y) end)}
      #{Enum.map_join(walls, "\n", fn {x, y} -> wall_svg(x, y) end)}
    </svg>
    """
  end

  defp hive_svg(x, y) do
    """
    <circle cx="#{x}" cy="#{y}" r="10" fill="yellow" stroke="black" stroke-width="2"/>
    """
  end

  defp wall_svg(x, y) do
    """
    <rect x="#{x}" y="#{y}" width="20" height="20" fill="gray" stroke="black" stroke-width="1"/>
    """
  end
end

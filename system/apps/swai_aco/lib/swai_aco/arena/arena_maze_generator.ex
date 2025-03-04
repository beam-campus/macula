defmodule MazeGenerator do
  defstruct x: 0, y: 0, z: 0

  def generate_maze(%MazeGenerator{x: width, y: height} = dimensions, complexity) do
    # Initialize the grid with walls
    grid = for _ <- 1..height do
      for _ <- 1..width,
      do: :wall
    end
    # Start the maze generation
    {maze, _} = carve_paths(grid, {1, 1}, complexity)

    # Convert the maze to SVG
    maze_to_svg(maze, dimensions)
  end

  defp carve_paths(grid, {x, y}, complexity) do
    # Mark the current cell as a path
    grid = List.update_at(grid, y, fn row -> List.replace_at(row, x, :path) end)

    # Shuffle directions to ensure randomness
    directions = Enum.shuffle([{0, 1}, {1, 0}, {0, -1}, {-1, 0}])

    Enum.reduce_while(directions, {grid, complexity}, fn {dx, dy}, {grid, complexity} ->
      nx = x + dx * 2
      ny = y + dy * 2

      if valid_position?(grid, {nx, ny}) and grid |> Enum.at(ny) |> Enum.at(nx) == :wall and complexity > 0 do
        # Carve a path to the new cell
        grid =
          grid
          |> List.update_at(y + dy, fn row -> List.replace_at(row, x + dx, :path) end)
          |> carve_paths({nx, ny}, complexity - 1)
          |> elem(0)

        {:cont, {grid, complexity - 1}}
      else
        {:cont, {grid, complexity}}
      end
    end)
  end

  defp valid_position?(grid, {x, y}) do
    x >= 0 and y >= 0 and y < length(grid) and x < length(List.first(grid))
  end

  defp maze_to_svg(maze, %MazeGenerator{x: width, y: height}) do
    cell_size = 10
    svg_header = "<svg xmlns='http://www.w3.org/2000/svg' width='#{width * cell_size}' height='#{height * cell_size}'>"
    svg_footer = "</svg>"

    paths =
      for {row, y} <- Enum.with_index(maze),
          {cell, x} <- Enum.with_index(row),
          cell == :wall do
        "<rect x='#{x * cell_size}' y='#{y * cell_size}' width='#{cell_size}' height='#{cell_size}' fill='black' />"
      end

    [svg_header | paths] ++ [svg_footer] |> Enum.join("\n")
  end
end

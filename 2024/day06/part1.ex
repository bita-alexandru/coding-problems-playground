defmodule Part1 do
  def solve do
    grid =
      File.read!("input.txt")
      |> String.split()
      |> Enum.map(&String.graphemes/1)

    nrows = length(grid)
    ncols = length(Enum.at(grid, 0))

    {y, x} =
      0..(nrows - 1)
      |> Enum.reduce_while({0, 0}, fn row, _yx ->
        {found?, col} =
          0..(ncols - 1)
          |> Enum.reduce_while({false, 0}, fn col, {_found?, _x} ->
            curr =
              grid
              |> Enum.at(row)
              |> Enum.at(col)

            if curr == "^", do: {:halt, {true, col}}, else: {:cont, {false, col}}
          end)

        if found?, do: {:halt, {row, col}}, else: {:cont, {row, col}}
      end)

    patrol(grid, [{y, x}, 0], MapSet.new([[{y, x}]]))
    |> MapSet.size()
  end

  defp patrol(grid, [{y, x}, direction], visited) do
    nrows = length(grid)
    ncols = length(Enum.at(grid, 0))
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]

    {next_y, next_x} =
      {y + Enum.at(Enum.at(directions, direction), 0),
       x + Enum.at(Enum.at(directions, direction), 1)}

    if next_y >= nrows or next_y < 0 or next_x >= ncols or next_x < 0 do
      visited
    else
      if Enum.at(Enum.at(grid, next_y), next_x) == "#" do
        next_direction = rem(direction + 1, 4)
        patrol(grid, [{y, x}, next_direction], visited)
      else
        patrol(grid, [{next_y, next_x}, direction], MapSet.put(visited, [{next_y, next_x}]))
      end
    end
  end
end

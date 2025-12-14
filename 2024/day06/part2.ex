defmodule Part2 do
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

    {visited, _loop?} =
      patrol(
        grid,
        [0, {y, x}, 0],
        MapSet.new([[0, {y, x}, 0]]),
        MapSet.new([[{y, x}, 0]])
      )

    path =
      visited
      |> MapSet.to_list()
      |> Enum.sort()

    make_loops(grid, path, 0, MapSet.new())
  end

  defp make_loops(grid, path, i, loops_trace) do
    if i + 1 >= length(path) do
      0
    else
      [_step, {y, x}, _direction] = Enum.at(path, i)
      [_next_step, {next_y, next_x}, next_direction] = Enum.at(path, i + 1)

      if MapSet.member?(loops_trace, [{next_y, next_x}]) or Enum.at(Enum.at(grid, next_y), next_x) == "^" do
        make_loops(grid, path, i + 1, loops_trace)
      else
        next_grid =
          grid
          |> List.replace_at(next_y, grid |> Enum.at(next_y) |> List.replace_at(next_x, "O"))

        {_visited, loop?} =
          patrol(
            next_grid,
            [0, {y, x}, next_direction],
            MapSet.new([[0, {y, x}, next_direction]]),
            MapSet.new([[{y, x}, next_direction]])
          )

        make_loops(
          grid,
          path,
          i + 1,
          MapSet.put(loops_trace, [{next_y, next_x}])
        ) + if(loop?, do: 1, else: 0)
      end
    end
  end

  defp patrol(grid, [step, {y, x}, direction], visited, steps_trace) do
    nrows = length(grid)
    ncols = length(Enum.at(grid, 0))
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]

    {next_y, next_x} =
      {y + Enum.at(Enum.at(directions, direction), 0),
       x + Enum.at(Enum.at(directions, direction), 1)}

    if next_y >= nrows or next_y < 0 or next_x >= ncols or next_x < 0 do
      {visited, false}
    else
      if Enum.at(Enum.at(grid, next_y), next_x) in ["#", "O"] do
        next_direction = rem(direction + 1, 4)

        patrol(
          grid,
          [step, {y, x}, next_direction],
          visited,
          steps_trace
        )
      else
        if MapSet.member?(steps_trace, [{next_y, next_x}, direction]) do
          {visited, true}
        else
          patrol(
            grid,
            [step + 1, {next_y, next_x}, direction],
            MapSet.put(visited, [step + 1, {next_y, next_x}, direction]),
            MapSet.put(steps_trace, [{next_y, next_x}, direction])
          )
        end
      end
    end
  end
end

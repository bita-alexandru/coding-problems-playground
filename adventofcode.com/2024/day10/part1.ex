defmodule Part1 do
  def solve do
    grid =
      "input.txt"
      |> File.stream!()
      |> Enum.map(
        &(String.trim(&1)
          |> String.graphemes()
          |> Enum.map(fn val -> String.to_integer(val) end))
      )

    nrows = length(grid)
    ncols = grid |> Enum.at(0) |> length()

    trailheads =
      grid
      |> Enum.with_index()
      |> Enum.reduce([], fn {row, i}, acc_trailheads ->
        ijs =
          row
          |> Enum.with_index()
          |> Enum.reduce([], fn {col, j}, acc_ijs ->
            if col == 0 do
              [[i, j] | acc_ijs]
            else
              acc_ijs
            end
          end)

        acc_trailheads ++ ijs
      end)

    get_score = fn self, [y, x], visited ->
      curr_val = grid |> Enum.at(y) |> Enum.at(x)

      if curr_val == 9 do
        [{y, x}]
      else
        directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]

        directions
        |> Enum.flat_map(fn [dy, dx] ->
          [next_y, next_x] = [y + dy, x + dx]

          if next_y < 0 or next_y >= nrows or next_x < 0 or next_x >= ncols do
            []
          else
            next_val = grid |> Enum.at(next_y) |> Enum.at(next_x)

            if curr_val - next_val == -1 and !MapSet.member?(visited, [next_y, next_x]) do
              self.(self, [next_y, next_x], MapSet.put(visited, [next_y, next_x]))
            else
              []
            end
          end
        end)
      end
    end

    scores =
      trailheads
      |> Enum.map(fn [y, x] ->
        get_score.(get_score, [y, x], MapSet.new())
      end)
      |> Enum.flat_map(&MapSet.new/1)
      |> length()
  end
end

defmodule Part1 do
  def solve do
    grid =
      "input.txt"
      |> File.stream!()
      |> Enum.map(&(String.trim(&1) |> String.graphemes()))

    [nrows, ncols] = [length(grid), Enum.at(grid, 0) |> length]

    antennas =
      grid
      |> Enum.with_index()
      |> Enum.reduce([], fn {line, row}, acc_row ->
        antennas_col =
          line
          |> Enum.with_index()
          |> Enum.reduce([], fn {cell, col}, acc_col ->
            if cell == "." do
              acc_col
            else
              [{[row, col], cell} | acc_col]
            end
          end)

        antennas_col ++ acc_row
      end)

    nantennas = length(antennas)

    antinodes =
      antennas
      |> Enum.with_index()
      |> Enum.reduce([], fn {antenna, i}, acc_i ->
        {[a_row, a_col], a_cell} = antenna

        acc =
          antennas
          |> Enum.slice(i + 1, nantennas)
          |> Enum.filter(fn {[_y, _x], cell} -> cell == a_cell end)
          |> Enum.reduce([], fn {[y, x], _cell}, acc_j ->
            [dy, dx] = [a_row - y, a_col - x]

            [antinode_a, antinode_b] =
              cond do
                dy < 0 and dx < 0 ->
                  [{a_row - abs(dy), a_col - abs(dx)}, {y + abs(dy), x + abs(dx)}]

                dy < 0 and dx >= 0 ->
                  [{a_row - abs(dy), a_col + abs(dx)}, {y + abs(dy), x - abs(dx)}]

                dy >= 0 and dx < 0 ->
                  [{a_row + abs(dy), a_col - abs(dx)}, {y - abs(dy), x + abs(dx)}]

                dy >= 0 and dx >= 0 ->
                  [{a_row + abs(dy), a_col + abs(dx)}, {y - abs(dy), x - abs(dx)}]
              end

            [antinode_a, antinode_b] ++ acc_j
          end)

        acc ++ acc_i
      end)
      |> Enum.reject(fn {y, x} -> y < 0 or y >= nrows or x < 0 or x >= ncols end)
      |> MapSet.new()

    antinodes
    |> MapSet.size()
  end
end

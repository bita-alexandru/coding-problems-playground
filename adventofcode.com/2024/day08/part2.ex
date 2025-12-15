defmodule Part2 do
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
          |> Enum.reduce([], fn {[y, x], _yxcell}, acc_j ->
            [dy, dx] = [a_row - y, a_col - x]

            get_antinodes = fn [cy, cx], [dy, dx] ->
              Stream.unfold([cy, cx], fn [r, c] ->
                if r < 0 or r >= nrows or c < 0 or c >= ncols do
                  nil
                else
                  {[r, c], [r + dy, c + dx]}
                end
              end)
              |> Enum.to_list()
            end

            antinodes_ab =
              cond do
                dy < 0 and dx < 0 ->
                  get_antinodes.([a_row, a_col], [-abs(dy), -abs(dx)]) ++
                    get_antinodes.([y, x], [abs(dy), abs(dx)])

                dy < 0 and dx >= 0 ->
                  get_antinodes.([a_row, a_col], [-abs(dy), abs(dx)]) ++
                    get_antinodes.([y, x], [abs(dy), -abs(dx)])

                dy >= 0 and dx < 0 ->
                  get_antinodes.([a_row, a_col], [abs(dy), -abs(dx)]) ++
                    get_antinodes.([y, x], [-abs(dy), abs(dx)])

                dy >= 0 and dx >= 0 ->
                  get_antinodes.([a_row, a_col], [abs(dy), abs(dx)]) ++
                    get_antinodes.([y, x], [-abs(dy), -abs(dx)])
              end

            antinodes_ab ++ acc_j
          end)

        acc ++ acc_i
      end)
      |> Enum.reject(fn [y, x] -> y < 0 or y >= nrows or x < 0 or x >= ncols end)
      |> MapSet.new()

    antinodes
    |> MapSet.size()
  end
end

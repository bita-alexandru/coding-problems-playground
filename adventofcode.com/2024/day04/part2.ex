defmodule Part2 do
  def solve do
    xmas =
      File.read!("input.txt")
      |> String.split()
      |> Enum.map(&String.graphemes/1)

    nrows = length(xmas)
    ncols = length(Enum.at(xmas, 0))

    Enum.reduce(0..(nrows - 1), 0, fn row, count ->
      count +
        Enum.reduce(0..(ncols - 1), 0, fn col, ok ->
          if Enum.at(Enum.at(xmas, row), col) == "A" do
            if row - 1 >= 0 and row + 1 < nrows and col - 1 >= 0 and col + 1 < ncols do
              [nw, ne, sw, se] = [
                Enum.at(Enum.at(xmas, row - 1), col - 1),
                Enum.at(Enum.at(xmas, row - 1), col + 1),
                Enum.at(Enum.at(xmas, row + 1), col - 1),
                Enum.at(Enum.at(xmas, row + 1), col + 1)
              ]

              cond do
                [nw, ne] == ["M", "M"] and [se, sw] == ["S", "S"] ->
                  ok + 1

                [nw, ne] == ["S", "S"] and [se, sw] == ["M", "M"] ->
                  ok + 1

                [nw, sw] == ["S", "S"] and [ne, se] == ["M", "M"] ->
                  ok + 1

                [nw, sw] == ["M", "M"] and [ne, se] == ["S", "S"] ->
                  ok + 1

                true ->
                  ok
              end
            else
              ok
            end
          else
            ok
          end
        end)
    end)
  end
end

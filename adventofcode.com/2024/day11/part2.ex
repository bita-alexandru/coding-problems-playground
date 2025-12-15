defmodule Part2 do
  def solve do
    stones =
      "input.txt"
      |> File.read!()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

    stones_after_blinks =
      1..75
      |> Enum.reduce(stones, fn _blink, acc_stones ->
        acc_stones
        |> Enum.reduce(Map.new(), fn {stone, count}, acc ->
          cond do
            stone == 0 ->
              Map.update(acc, 1, count, &(&1 + count))

            stone |> Integer.to_string() |> String.length() |> rem(2) == 0 ->
              stone_str = stone |> Integer.to_string()
              stone_str_mid = stone_str |> String.length() |> div(2)

              [left_half, right_half] = [
                stone_str |> String.slice(0..(stone_str_mid - 1)) |> String.to_integer(),
                stone_str
                |> String.slice(stone_str_mid..(stone_str_mid * 2))
                |> String.to_integer()
              ]

              acc
              |> Map.update(left_half, count, &(&1 + count))
              |> Map.update(right_half, count, &(&1 + count))

            true ->
              Map.update(acc, stone * 2024, count, &(&1 + count))
          end
        end)
      end)

    stones_after_blinks
    |> Map.to_list()
    |> Enum.map(fn {_stone, count} -> count end)
    |> Enum.sum()
  end
end

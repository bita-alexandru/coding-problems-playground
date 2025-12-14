defmodule Part1 do
  def solve do
    stones =
      "input.txt"
      |> File.read!()
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    stones_after_blinks =
      1..25
      |> Enum.reduce(stones, fn _blink, acc_stones ->
        acc_stones
        |> Enum.reduce([], fn stone, acc ->
          cond do
            stone == 0 ->
              [1 | acc]

            stone |> Integer.to_string() |> String.length() |> rem(2) == 0 ->
              stone_str = stone |> Integer.to_string()
              stone_str_mid = stone_str |> String.length() |> div(2)

              [left_half, right_half] = [
                stone_str |> String.slice(0..(stone_str_mid - 1)) |> String.to_integer(),
                stone_str
                |> String.slice(stone_str_mid..(stone_str_mid * 2))
                |> String.to_integer()
              ]

              [left_half | [right_half | acc]]

            true ->
              [stone * 2024 | acc]
          end
        end)
      end)

    stones_after_blinks
    |> length()
  end
end

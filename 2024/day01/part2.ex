defmodule Part2 do
  def solve do
      {numbers_left, frequency_map} =
        "input.txt"
        |> File.stream!()
        |> Enum.reduce({[], %{}}, fn line, {acc_numbers, acc_frequency} ->
          [n_left, n_right] =
            line
            |> String.split()
            |> Enum.map(&String.to_integer/1)
          {
            [n_left | acc_numbers],
            Map.update(acc_frequency, n_right, 1, &(&1 + 1))
          }
        end)

      Enum.reduce(numbers_left, 0, &(&1*Map.get(frequency_map, &1, 0) + &2))
  end
end

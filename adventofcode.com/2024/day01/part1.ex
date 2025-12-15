defmodule Part1 do
  def solve do
      {numbers_left, numbers_right} =
        "input.txt"
        |> File.stream!()
        |> Enum.reduce({[], []}, fn line, {acc_left, acc_right} ->
          [n_left, n_right] =
            line
            |> String.split()
            |> Enum.map(&String.to_integer/1)
          {[n_left | acc_left], [n_right | acc_right]}
        end)
        |> then(fn {left, right} ->
          {Enum.sort(left), Enum.sort(right)}
        end)

      Enum.zip(numbers_left, numbers_right)
      |> Enum.map(fn {x, y} -> abs(x - y) end)
      |> Enum.sum()
  end
end

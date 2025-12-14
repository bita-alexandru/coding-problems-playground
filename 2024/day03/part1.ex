defmodule Part1 do
  def solve do
    corrupted_memory = File.read!("input.txt")

    ~r/mul\((\d{1,3}),(\d{1,3})\)/
    |> Regex.scan(corrupted_memory)
    |> Enum.map(fn [_mul, x, y] ->
      String.to_integer(x)*String.to_integer(y)
    end)
    |> Enum.sum()
  end
end

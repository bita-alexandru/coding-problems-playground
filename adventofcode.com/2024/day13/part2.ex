defmodule Part2 do
  def solve do
    machines =
      "input.txt"
      |> File.read!()
      |> String.split("\r\n\r\n")
      |> Enum.map(fn ba_bb_p ->
        ba_bb_p
        |> String.split("\n")
        |> Enum.map(fn line ->
          line
          |> String.trim()
          |> String.split(":")
          |> Enum.at(1)
          |> String.split(",")
          |> Enum.map(fn xy_op_val ->
            xy_op_val
            |> String.trim()
            |> String.slice(2..-1//1)
            |> String.to_integer()
          end)
        end)
      end)

    machines
    |> Enum.map(fn [button_a, button_b, prize] ->
      [xa, ya] = button_a
      [xb, yb] = button_b
      [xp, yp] = prize
      [c1, c2] = [xp + 10_000_000_000_000, yp + 10_000_000_000_000]
      [a1, b1] = [xa, xb]
      [a2, b2] = [ya, yb]

      a = (c1 * b2 - b1 * c2) / (a1 * b2 - b1 * a2)
      b = (a1 * c2 - c1 * a2) / (a1 * b2 - b1 * a2)

      cond do
        a < 0 or b < 0 -> 0
        [trunc(a), trunc(b)] == [a, b] -> 3 * a + b
        true -> 0
      end
    end)
    |> Enum.sum()
  end
end

defmodule Part1 do
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

      0..100
      |> Enum.reduce(nil, fn b, acc ->
        a =
          (xp + yp - (xb + yb) * b)
          |> div(xa + ya)

        if xa * a + xb * b == xp and ya * a + yb * b == yp do
          cost = a * 3 + b
          if is_nil(acc) or cost < acc, do: cost, else: acc
        else
          acc
        end
      end) || 0
    end)
    |> Enum.sum()
  end
end

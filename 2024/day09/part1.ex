defmodule Part1 do
  def solve do
    disk =
      "input.txt"
      |> File.read!()
      |> String.trim()
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    blocks =
      disk
      |> Enum.with_index()
      |> Enum.flat_map(fn {val, i} ->
        id = if rem(i, 2) == 0, do: div(i, 2), else: "."
        if val == 0, do: [], else: for(_ <- 1..val, do: id)
      end)

    blocks_with_index = blocks |> Enum.with_index()

    blocks_nospace =
      blocks_with_index
      |> Enum.reject(fn {val, _i} -> val == "." end)
      |> Enum.reverse()

    {ordered_disk, _} =
      blocks_with_index
      |> Enum.reduce_while({[], blocks_nospace}, fn {val, i},
                                                    {acc_disk, [acc_block | acc_tail]} ->
        if acc_block |> elem(1) < i do
          {:halt, {acc_disk, [acc_block | acc_tail]}}
        else
          if val != "." do
            {:cont, {[{val, i} | acc_disk], [acc_block | acc_tail]}}
          else
            {:cont, {[acc_block | acc_disk], acc_tail}}
          end
        end
      end)

    ordered_disk_map =
      ordered_disk
      |> Enum.map(fn {val, _i} -> val end)
      |> Enum.reverse()

    ordered_disk_map
    |> Enum.with_index()
    |> Enum.map(fn {val, i} -> val * i end)
    |> Enum.sum()
  end
end

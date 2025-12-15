defmodule Part2 do
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
        id = if rem(i, 2) == 0, do: Integer.to_string(div(i, 2)), else: "."
        if val == 0, do: [], else: for(_ <- 1..val, do: id)
      end)

    blocks_with_index = blocks |> Enum.with_index()

    file_map =
      blocks_with_index
      |> Enum.reduce(%{}, fn {val, i}, acc ->
        if val != "." and Map.get(acc, val) == nil do
          Map.put(acc, val, {i, Enum.count(blocks, &(&1 == val))})
        else
          acc
        end
      end)

    filesystem =
      (map_size(file_map) - 1)..0
      |> Enum.reduce(blocks, fn i, acc_blocks ->
        istr = Integer.to_string(i)
        {val_start, val_count} = Map.get(file_map, istr)

        free_blocks =
          acc_blocks
          |> Enum.with_index()
          |> Enum.filter(fn {val, _i} -> val == "." end)
          |> Enum.map(fn {_val, i} -> i end)

        free_idx_start =
          0..length(free_blocks)
          |> Enum.reduce_while(nil, fn j, _free_idx_start ->
            j_idx = Enum.at(free_blocks, j)

            if j + val_count > length(free_blocks) or j_idx > val_start do
              {:halt, nil}
            else
              consecutive? = Enum.at(free_blocks, j + val_count - 1) == j_idx + val_count - 1

              if consecutive?, do: {:halt, j_idx}, else: {:cont, nil}
            end
          end)

        if !is_nil(free_idx_start) do
          free_idx_last = free_idx_start + val_count
          replace_file_blocks = for _ <- 1..val_count, do: istr
          replace_free_blocks = for _ <- 1..val_count, do: "."

          Enum.slice(acc_blocks, 0, free_idx_start) ++
            replace_file_blocks ++
            Enum.slice(acc_blocks, free_idx_last, val_start - free_idx_last) ++
            replace_free_blocks ++
            Enum.slice(acc_blocks, val_start + val_count, length(acc_blocks))
        else
          acc_blocks
        end
      end)

    filesystem
    |> Enum.with_index()
    |> Enum.map(fn {val, i} ->
      if val == "." do
        0
      else
        String.to_integer(val) * i
      end
    end)
    |> Enum.sum()
  end
end

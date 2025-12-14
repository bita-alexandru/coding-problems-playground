defmodule Part1 do
  def solve do
    "input.txt"
    |> File.stream!()
    |> Enum.reduce(0, fn line, safe_paths ->
      path =
        line
        |> String.split()
        |> Enum.map(&String.to_integer/1)

      if safe_path?(nil, path) do
        safe_paths + 1
      else
        safe_paths
      end
    end)
  end

  defp safe_path?(_, []), do: true
  defp safe_path?(_, [_]), do: true

  defp safe_path?(direction, [prev, curr | tail]) do
    diff = curr - prev
    abs_diff = abs(diff)
    curr_direction = sign(diff)

    cond do
      !is_nil(direction) and direction != curr_direction -> false
      abs_diff >= 1 and abs_diff <= 3 -> safe_path?(curr_direction, [curr | tail])
      true -> false
    end
  end

  defp sign(number) when number >= 0, do: 1
  defp sign(number) when number < 0, do: -1
end

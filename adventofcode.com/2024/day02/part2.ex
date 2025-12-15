defmodule Part2 do
  def solve do
    "input.txt"
    |> File.stream!()
    |> Enum.reduce(0, fn line, safe_paths ->
      path =
        line
        |> String.split()
        |> Enum.map(&String.to_integer/1)

      traverser =
        &Enum.reduce_while(&1, {nil, 0, nil}, fn
          curr, {prev, toleration, direction} ->
            cond do
              is_nil(prev) ->
                {:cont, {curr, toleration, direction}}

              toleration <= 1 ->
                diff = curr - prev
                abs_diff = abs(diff)
                curr_direction = sign(diff)

                cond do
                  !is_nil(direction) and direction != curr_direction ->
                    {:cont, {prev, toleration + 1, direction}}

                  abs_diff >= 1 and abs_diff <= 3 ->
                    {:cont, {curr, toleration, curr_direction}}

                  true ->
                    {:cont, {prev, toleration + 1, direction}}
                end

              true ->
                {:halt, {curr, toleration, direction}}
            end
        end)

      {{_, toleration, _}, {_, toleration_rev, _}} =
        {traverser.(path), traverser.(Enum.reverse(path))}

      safe_paths + if toleration <= 1 or toleration_rev <= 1, do: 1, else: 0
    end)
  end

  defp sign(number) when number >= 0, do: 1
  defp sign(number) when number < 0, do: -1
end

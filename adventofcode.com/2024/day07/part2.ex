defmodule Part2 do
  def solve do
    {values, calibrators} =
      "input.txt"
      |> File.stream!()
      |> Enum.reduce({[], []}, fn line, {acc_l, acc_r} ->
        [left, right] = String.split(line, ":")
        left_val = left |> String.to_integer()
        right_vals = right |> String.split() |> Enum.map(&String.to_integer/1)
        {[left_val | acc_l], [right_vals | acc_r]}
      end)

    values
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, i}, sum ->
      calibs = Enum.at(calibrators, i)
      n = length(calibs)
      can_evaluate? = evaluate(n, calibs, val, 1, Enum.at(calibs, 0))

      sum + if can_evaluate?, do: val, else: 0
    end)
  end

  defp evaluate(n, calibs, target, i, curr_val) do
    if i >= n do
      curr_val == target
    else
      calib = Enum.at(calibs, i)

      cond do
        evaluate(n, calibs, target, i + 1, curr_val + calib) ->
          true

        evaluate(n, calibs, target, i + 1, curr_val * calib) ->
          true

        true ->
          evaluate(
            n,
            calibs,
            target,
            i + 1,
            (Integer.to_string(curr_val) <> Integer.to_string(calib)) |> String.to_integer()
          )
      end
    end
  end
end

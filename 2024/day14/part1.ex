defmodule Part1 do
  def solve do
    {positions, velocities} =
      "input.txt"
      |> File.stream!()
      |> Enum.reduce({[], []}, fn line, {acc_positions, acc_velocities} ->
        line
        |> String.trim()
        |> String.split()
        |> then(fn [postion, velocity] ->
          position_values =
            postion
            |> String.split("=")
            |> Enum.at(1)
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)
            |> List.to_tuple()

          velocity_values =
            velocity
            |> String.split("=")
            |> Enum.at(1)
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)
            |> List.to_tuple()

          {[position_values | acc_positions], [velocity_values | acc_velocities]}
        end)
      end)
      |> then(fn {left, right} ->
        {left |> Enum.reverse(), right |> Enum.reverse()}
      end)

    robots = Enum.zip(positions, velocities)

    [nrows, ncols] = [103, 101]
    [hrows, hcols] = [51, 50]

    initial_map =
      robots
      |> Enum.with_index()
      |> Enum.reduce(Map.new(), fn {{{x, y}, {vx, vy}}, i}, acc_robots ->
        acc_robots
        |> Map.put(i, {{y, x}, {vy, vx}})
      end)

    final_map =
      1..100
      |> Enum.reduce(initial_map, fn _second, acc_second ->
        acc_second
        |> Enum.reduce(acc_second, fn {i, {{y, x}, {vy, vx}}}, acc ->
          {ny, nx} = {(y + vy + nrows) |> rem(nrows), (x + vx + ncols) |> rem(ncols)}

          acc
          |> Map.update!(i, fn _ -> {{ny, nx}, {vy, vx}} end)
        end)
      end)

    {q1, q2, q3, q4} = {
      final_map |> Map.filter(fn {_, {{y, x}, _}} -> y < hrows and x < hcols end),
      final_map |> Map.filter(fn {_, {{y, x}, _}} -> y < hrows and x > hcols end),
      final_map |> Map.filter(fn {_, {{y, x}, _}} -> y > hrows and x < hcols end),
      final_map |> Map.filter(fn {_, {{y, x}, _}} -> y > hrows and x > hcols end)
    }

    for q <- [q1, q2, q3, q4] do
      q
      |> map_size()
    end
    |> Enum.product()
  end
end

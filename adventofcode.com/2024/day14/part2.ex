defmodule Part2 do
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

    1..100_000
    |> Enum.reduce_while({MapSet.new(), initial_map, [0, :infinity]}, fn second,
                                                                         {acc_maps_mapset,
                                                                          acc_map,
                                                                          [
                                                                            acc_min_idx,
                                                                            acc_min_val
                                                                          ]} ->
      curr_map =
        acc_map
        |> Enum.reduce(acc_map, fn {i, {{y, x}, {vy, vx}}}, acc ->
          {ny, nx} = {(y + vy + nrows) |> rem(nrows), (x + vx + ncols) |> rem(ncols)}

          acc
          |> Map.update!(i, fn _ -> {{ny, nx}, {vy, vx}} end)
        end)

      {q1, q2, q3, q4} = {
        curr_map |> Map.filter(fn {_, {{y, x}, _}} -> y < hrows and x < hcols end),
        curr_map |> Map.filter(fn {_, {{y, x}, _}} -> y < hrows and x > hcols end),
        curr_map |> Map.filter(fn {_, {{y, x}, _}} -> y > hrows and x < hcols end),
        curr_map |> Map.filter(fn {_, {{y, x}, _}} -> y > hrows and x > hcols end)
      }

      curr_safety =
        for q <- [q1, q2, q3, q4] do
          q
          |> map_size()
        end
        |> Enum.product()

      if MapSet.member?(acc_maps_mapset, curr_map) do
        {:halt, acc_min_idx}
      else
        min_safety = min(curr_safety, acc_min_val)
        min_idx = if min_safety == curr_safety, do: second, else: acc_min_idx
        {:cont, {MapSet.put(acc_maps_mapset, curr_map), curr_map, [min_idx, min_safety]}}
      end
    end)
  end
end

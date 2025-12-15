defmodule Part1 do
  def solve do
    grid =
      "input.txt"
      |> File.stream!()
      |> Enum.with_index()
      |> Enum.reduce(Map.new(), fn {line, i}, acc_map ->
        line
        |> String.trim()
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc_map, fn {val, j}, acc ->
          acc |> Map.put({i, j}, val)
        end)
      end)

    [start_pos, end_pos, free_pos] =
      [
        grid |> Map.filter(fn {_k, v} -> v == "S" end) |> Map.keys() |> List.first(),
        grid |> Map.filter(fn {_k, v} -> v == "E" end) |> Map.keys() |> List.first(),
        grid |> Map.filter(fn {_k, v} -> v == "." end) |> Map.keys()
      ]

    directions = [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]

    unvisited_map =
      [{end_pos, :infinity} | Enum.map(free_pos, fn yx -> {yx, :infinity} end)]
      |> Enum.flat_map(fn {pos, dist} ->
        directions
        |> Enum.map(fn dir ->
          {{pos, dir}, dist}
        end)
      end)
      |> Map.new()
      |> Map.put({start_pos, {0, 1}}, 0)

    unvisited_pq = unvisited_map |> Enum.map(fn {k, v} -> {v, k} end) |> Enum.sort()

    distances =
      explore_grid(
        unvisited_map,
        unvisited_pq,
        end_pos,
        Map.new()
      )

    distances |> Map.get(end_pos)
  end

  defp explore_grid(unvisited_map, unvisited_pq, end_pos, visited_map) do
    dirs = [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]
    costs = [1, 1001, 1001, 2001]

    curr_node = unvisited_pq |> List.first()

    cond do
      curr_node |> is_nil ->
        visited_map

      ({curr_dist, _} = curr_node) &&
          curr_dist == :infinity ->
        visited_map

      ({curr_dist, {curr_pos, _}} = curr_node) && curr_pos == end_pos ->
        visited_map |> Map.put(curr_pos, curr_dist)

      true ->
        {curr_dist, {curr_pos, curr_dir}} = curr_node
        {y, x} = curr_pos
        dir = dirs |> Enum.find_index(&(&1 == curr_dir))

        turns =
          [
            curr_dir,
            Enum.at(dirs, rem(dir + 1, 4)),
            Enum.at(dirs, dir - 1),
            Enum.at(dirs, rem(dir + 2, 4))
          ]
          |> Enum.take(3)

        neighbours =
          turns
          |> Enum.with_index()
          |> Enum.flat_map(fn {{dy, dx}, d} ->
            nynx = {y + dy, x + dx}

            if Map.get(unvisited_map, {nynx, {dy, dx}}) |> is_nil() do
              []
            else
              [{nynx, d}]
            end
          end)

        {new_unvisited_map, new_unvisited_pq} =
          neighbours
          |> Enum.reduce({unvisited_map, unvisited_pq}, fn {nynx, d},
                                                           {acc_univisited_map, acc_univisited_pq} ->
            nynx_new_dir = Enum.at(turns, d)
            nynx_curr_dist = unvisited_map |> Map.get({nynx, nynx_new_dir})
            nynx_new_dist = curr_dist + Enum.at(costs, d)

            if nynx_new_dist < nynx_curr_dist do
              new_acc_unvisited_map =
                acc_univisited_map
                |> Map.update!({nynx, nynx_new_dir}, fn _ -> nynx_new_dist end)

              {
                new_acc_unvisited_map,
                [
                  {nynx_new_dist, {nynx, nynx_new_dir}}
                  | Enum.reject(acc_univisited_pq, fn {dist, {pos, dir}} ->
                      dist == nynx_curr_dist and pos == nynx and dir == nynx_new_dir
                    end)
                ]
              }
            else
              {
                acc_univisited_map,
                acc_univisited_pq
              }
            end
          end)
          |> then(fn {left, right} ->
            {
              left,
              right
              |> Enum.reject(fn {dist, {pos, dir}} ->
                dist == curr_dist and pos == curr_pos and dir == curr_dir
              end)
              |> Enum.sort()
            }
          end)

        new_visited_map =
          visited_map
          |> Map.update(curr_pos, curr_dist, fn prev_dist -> min(curr_dist, prev_dist) end)

        explore_grid(
          new_unvisited_map,
          new_unvisited_pq,
          end_pos,
          new_visited_map
        )
    end
  end
end

defmodule Part2 do
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

    unvisited_map =
      Map.new(
        [{start_pos, 0}, {end_pos, :infinity}] ++
          (free_pos |> Enum.map(fn yx -> {yx, :infinity} end))
      )

    unvisited_pq = unvisited_map |> Enum.map(fn {k, v} -> {v, k} end) |> Enum.sort()

    distances = explore_grid(unvisited_map, unvisited_pq, end_pos, Map.new())
    path = get_path(end_pos, start_pos, distances, [end_pos])

    cheats = get_cheats(path)
    cheats_fr = cheats |> Enum.frequencies() |> Enum.to_list() |> Enum.sort()
    cheats |> Enum.filter(fn val -> val >= 100 end) |> length()
  end

  defp get_cheats(path) do
    directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    path_ms = MapSet.new(path)
    diags = [[-1, 1], [-1, -1], [1, -1], [1, 1]]

    path
    |> Enum.flat_map(fn yx ->
      {y, x} = yx

      frees =
        1..20
        |> Enum.flat_map(fn i ->
          directions
          |> Enum.with_index()
          |> Enum.flat_map(fn {[dy, dx], d} ->
            {ny, nx} = nynx = {y + i * dy, x + i * dx}
            nynx_member = if MapSet.member?(path_ms, nynx), do: [{nynx, i}], else: []
            [diag_y, diag_x] = diags |> Enum.at(d)

            diag_members =
              1..(i - 1)//1
              |> Enum.flat_map(fn j ->
                dydx = {ny + j * diag_y, nx + j * diag_x}
                if MapSet.member?(path_ms, dydx), do: [{dydx, i}], else: []
              end)

            nynx_member ++ diag_members
          end)
        end)

      frees
      |> Enum.map(fn {fyfx, ps} ->
        Enum.find_index(path, &(&1 == fyfx)) - Enum.find_index(path, &(&1 == yx)) - ps
      end)
    end)
  end

  defp get_path(curr_pos, start_pos, distances, path) do
    if curr_pos == start_pos do
      path
    else
      {y, x} = curr_pos
      directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]

      {_prev_dist, prev_pos} =
        directions
        |> Enum.flat_map(fn [dy, dx] ->
          nynx = {y + dy, x + dx}

          case Map.get(distances, nynx) do
            nil -> []
            nynx_dist -> [{nynx_dist, nynx}]
          end
        end)
        |> Enum.sort()
        |> List.first()

      get_path(prev_pos, start_pos, distances, [prev_pos | path])
    end
  end

  defp explore_grid(unvisited_map, unvisited_pq, end_pos, visited_map) do
    curr_node = unvisited_pq |> List.first()

    cond do
      curr_node |> is_nil ->
        visited_map

      ({curr_dist, _} = curr_node) &&
          curr_dist == :infinity ->
        visited_map

      ({curr_dist, curr_pos} = curr_node) && curr_pos == end_pos ->
        visited_map |> Map.put(curr_pos, curr_dist)

      true ->
        {curr_dist, curr_pos} = curr_node
        {y, x} = curr_pos
        directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]

        neighbours =
          directions
          |> Enum.flat_map(fn [dy, dx] ->
            nynx = {y + dy, x + dx}

            if Map.get(unvisited_map, nynx) |> is_nil() do
              []
            else
              [nynx]
            end
          end)

        {new_unvisited_map, new_unvisited_pq} =
          neighbours
          |> Enum.reduce({unvisited_map, unvisited_pq}, fn nynx,
                                                           {acc_univisited_map, acc_univisited_pq} ->
            nynx_curr_dist = unvisited_map |> Map.get(nynx)
            nynx_new_dist = curr_dist + 1

            if nynx_new_dist < nynx_curr_dist do
              {
                acc_univisited_map |> Map.update!(nynx, fn _ -> nynx_new_dist end),
                [
                  {nynx_new_dist, nynx}
                  | Enum.reject(acc_univisited_pq, fn {dist, yx} ->
                      yx == nynx and dist == nynx_curr_dist
                    end)
                ]
              }
            else
              {acc_univisited_map, acc_univisited_pq}
            end
          end)
          |> then(fn {left, right} ->
            {
              left,
              right
              |> Enum.reject(fn {dist, yx} ->
                yx == curr_pos and dist == curr_dist
              end)
              |> Enum.sort()
            }
          end)

        new_visited_map =
          visited_map
          |> Map.put(curr_pos, curr_dist)

        explore_grid(new_unvisited_map, new_unvisited_pq, end_pos, new_visited_map)
    end
  end
end

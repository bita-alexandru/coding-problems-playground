defmodule Part2 do
  def solve do
    [grid, moves] =
      "input.txt"
      |> File.read!()
      |> String.split("\r\n\r\n")
      |> then(fn [left, right] ->
        [
          left
          |> String.split()
          |> Enum.map(&String.graphemes/1),
          right |> String.split() |> List.to_string() |> String.graphemes()
        ]
      end)

    wide_grid =
      grid
      |> Enum.reduce([], fn row, acc_row ->
        curr_row =
          row
          |> Enum.reduce([], fn col, acc_col ->
            case col do
              "#" -> ["#" | ["#" | acc_col]]
              "O" -> ["]" | ["[" | acc_col]]
              "." -> ["." | ["." | acc_col]]
              "@" -> ["." | ["@" | acc_col]]
            end
          end)
          |> Enum.reverse()

        [curr_row | acc_row]
      end)
      |> Enum.reverse()

    {wide_grid_map, robot_pos} =
      wide_grid
      |> Enum.with_index()
      |> Enum.reduce({%{}, {0, 0}}, fn {row, i}, {acc_row, acc_pos} ->
        row
        |> Enum.with_index()
        |> Enum.reduce({acc_row, acc_pos}, fn {col, j}, {acc_col, acc_pos} ->
          {
            if(col == ".", do: acc_col, else: acc_col |> Map.put({i, j}, col)),
            if(col == "@", do: {i, j}, else: acc_pos)
          }
        end)
      end)

    wide_grid_after_moves = move_robot(moves, wide_grid_map, robot_pos)

    wide_grid_after_moves
    |> Map.filter(fn {_ij, val} -> val == "[" end)
    |> Map.to_list()
    |> Enum.map(fn {{i, j}, _val} -> i * 100 + j end)
    |> Enum.sum()
  end

  defp move_robot([], grid_map, _robot_pos), do: grid_map

  defp move_robot([move | moves], grid_map, robot_pos) do
    {y, x} = robot_pos

    next_pos =
      case move do
        "^" -> {y - 1, x}
        ">" -> {y, x + 1}
        "v" -> {y + 1, x}
        "<" -> {y, x - 1}
      end

    {updated_map, updated_pos} =
      case Map.get(grid_map, next_pos) do
        nil ->
          {
            grid_map |> Map.delete(robot_pos) |> Map.put(next_pos, "@"),
            next_pos
          }

        "#" ->
          {
            grid_map,
            robot_pos
          }

        "[" ->
          {map_after_obstacle, obstacle_moved?} = move_obstacle(move, grid_map, next_pos, "[")

          if obstacle_moved? do
            {
              map_after_obstacle |> Map.delete(robot_pos) |> Map.put(next_pos, "@"),
              next_pos
            }
          else
            {grid_map, robot_pos}
          end

        "]" ->
          {map_after_obstacle, obstacle_moved?} = move_obstacle(move, grid_map, next_pos, "]")

          if obstacle_moved? do
            {
              map_after_obstacle |> Map.delete(robot_pos) |> Map.put(next_pos, "@"),
              next_pos
            }
          else
            {grid_map, robot_pos}
          end
      end

    move_robot(moves, updated_map, updated_pos)
  end

  defp move_obstacle(move, wide_grid_map, obstacle_pos1, obstacle_side1) do
    obstacle_side2 = if obstacle_side1 == "[", do: "]", else: "["
    {y1, x1} = obstacle_pos1
    {y2, x2} = obstacle_pos2 = if obstacle_side2 == "[", do: {y1, x1 - 1}, else: {y1, x1 + 1}

    {next_pos1, next_pos2} =
      case move do
        "^" -> {{y1 - 1, x1}, {y2 - 1, x2}}
        ">" -> {{y1, x1 + 1}, {y2, x2 + 1}}
        "v" -> {{y1 + 1, x1}, {y2 + 1, x2}}
        "<" -> {{y1, x1 - 1}, {y2, x2 - 1}}
      end

    if move in ["^", "v"] do
      case {Map.get(wide_grid_map, next_pos1), Map.get(wide_grid_map, next_pos2)} do
        {nil, nil} ->
          {
            wide_grid_map
            |> Map.delete(obstacle_pos1)
            |> Map.delete(obstacle_pos2)
            |> Map.put(next_pos1, obstacle_side1)
            |> Map.put(next_pos2, obstacle_side2),
            true
          }

        {"#", _} ->
          {wide_grid_map, false}

        {_, "#"} ->
          {wide_grid_map, false}

        {"[", "]"} when obstacle_side1 == "[" ->
          {map_after_next_obstacle, moved?} = move_obstacle(move, wide_grid_map, next_pos1, "[")

          if moved? do
            {
              map_after_next_obstacle
              |> Map.delete(obstacle_pos1)
              |> Map.delete(obstacle_pos2)
              |> Map.put(next_pos1, obstacle_side1)
              |> Map.put(next_pos2, obstacle_side2),
              true
            }
          else
            {
              map_after_next_obstacle,
              false
            }
          end

        {"]", "["} when obstacle_side1 == "[" ->
          {map_after_next_obstacle1, moved1?} = move_obstacle(move, wide_grid_map, next_pos1, "]")

          if moved1? do
            {map_after_next_obstacle2, moved2?} =
              move_obstacle(move, map_after_next_obstacle1, next_pos2, "[")

            if moved2? do
              {
                map_after_next_obstacle2
                |> Map.delete(obstacle_pos1)
                |> Map.delete(obstacle_pos2)
                |> Map.put(next_pos1, obstacle_side1)
                |> Map.put(next_pos2, obstacle_side2),
                true
              }
            else
              {
                map_after_next_obstacle1,
                false
              }
            end
          else
            {wide_grid_map, false}
          end

        {"[", "]"} when obstacle_side1 == "]" ->
          {map_after_next_obstacle1, moved1?} = move_obstacle(move, wide_grid_map, next_pos1, "[")

          if moved1? do
            {map_after_next_obstacle2, moved2?} =
              move_obstacle(move, map_after_next_obstacle1, next_pos2, "]")

            if moved2? do
              {
                map_after_next_obstacle2
                |> Map.delete(obstacle_pos1)
                |> Map.delete(obstacle_pos2)
                |> Map.put(next_pos1, obstacle_side1)
                |> Map.put(next_pos2, obstacle_side2),
                true
              }
            else
              {
                map_after_next_obstacle1,
                false
              }
            end
          else
            {wide_grid_map, false}
          end

        {"]", "["} when obstacle_side1 == "]" ->
          {map_after_next_obstacle, moved?} = move_obstacle(move, wide_grid_map, next_pos1, "]")

          if moved? do
            {
              map_after_next_obstacle
              |> Map.delete(obstacle_pos1)
              |> Map.delete(obstacle_pos2)
              |> Map.put(next_pos1, obstacle_side1)
              |> Map.put(next_pos2, obstacle_side2),
              true
            }
          else
            {
              map_after_next_obstacle,
              false
            }
          end

        {nil, _} ->
          {map_after_next_obstacle, moved?} =
            move_obstacle(move, wide_grid_map, next_pos2, Map.get(wide_grid_map, next_pos2))

          if moved? do
            {
              map_after_next_obstacle
              |> Map.delete(obstacle_pos1)
              |> Map.delete(obstacle_pos2)
              |> Map.put(next_pos1, obstacle_side1)
              |> Map.put(next_pos2, obstacle_side2),
              true
            }
          else
            {
              map_after_next_obstacle,
              false
            }
          end

        {_, nil} ->
          {map_after_next_obstacle, moved?} =
            move_obstacle(move, wide_grid_map, next_pos1, Map.get(wide_grid_map, next_pos1))

          if moved? do
            {
              map_after_next_obstacle
              |> Map.delete(obstacle_pos1)
              |> Map.delete(obstacle_pos2)
              |> Map.put(next_pos1, obstacle_side1)
              |> Map.put(next_pos2, obstacle_side2),
              true
            }
          else
            {
              map_after_next_obstacle,
              false
            }
          end
      end
    else
      case {Map.get(wide_grid_map, next_pos1), Map.get(wide_grid_map, next_pos2)} do
        {"#", _} ->
          {wide_grid_map, false}

        {_, "#"} ->
          {wide_grid_map, false}

        {nil, _} ->
          {
            wide_grid_map
            |> Map.delete(obstacle_pos1)
            |> Map.delete(obstacle_pos2)
            |> Map.put(next_pos1, obstacle_side1)
            |> Map.put(next_pos2, obstacle_side2),
            true
          }

        {_, nil} ->
          {
            wide_grid_map
            |> Map.delete(obstacle_pos1)
            |> Map.delete(obstacle_pos2)
            |> Map.put(next_pos1, obstacle_side1)
            |> Map.put(next_pos2, obstacle_side2),
            true
          }

        {"]", "["} ->
          {map_after_next_obstacle, moved?} = move_obstacle(move, wide_grid_map, next_pos2, "[")

          if moved? do
            {
              map_after_next_obstacle
              |> Map.delete(obstacle_pos1)
              |> Map.delete(obstacle_pos2)
              |> Map.put(next_pos1, obstacle_side1)
              |> Map.put(next_pos2, obstacle_side2),
              true
            }
          else
            {wide_grid_map, false}
          end

        {"[", "]"} ->
          {map_after_next_obstacle, moved?} = move_obstacle(move, wide_grid_map, next_pos2, "]")

          if moved? do
            {
              map_after_next_obstacle
              |> Map.delete(obstacle_pos1)
              |> Map.delete(obstacle_pos2)
              |> Map.put(next_pos1, obstacle_side1)
              |> Map.put(next_pos2, obstacle_side2),
              true
            }
          else
            {wide_grid_map, false}
          end
      end
    end
  end
end

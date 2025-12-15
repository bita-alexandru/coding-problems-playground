defmodule Part1 do
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

    {grid_map, robot_pos} =
      grid
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

    grid_after_moves = move_robot(moves, grid_map, robot_pos)

    grid_after_moves
    |> Map.filter(fn {_ij, val} -> val == "O" end)
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

        "O" ->
          {map_after_obstacle, obstacle_moved?} = move_obstacle(move, grid_map, next_pos)

          if obstacle_moved? do
            {
              map_after_obstacle |> Map.delete(robot_pos) |> Map.put(next_pos, "@"),
              next_pos
            }
          else
            {map_after_obstacle, robot_pos}
          end
      end

    move_robot(moves, updated_map, updated_pos)
  end

  defp move_obstacle(move, grid_map, obstacle_pos) do
    {y, x} = obstacle_pos

    next_pos =
      case move do
        "^" -> {y - 1, x}
        ">" -> {y, x + 1}
        "v" -> {y + 1, x}
        "<" -> {y, x - 1}
      end

    case Map.get(grid_map, next_pos) do
      nil ->
        {
          grid_map |> Map.delete(obstacle_pos) |> Map.put(next_pos, "O"),
          true
        }

      "#" ->
        {grid_map, false}

      "O" ->
        {map_after_next_obstacle, moved?} = move_obstacle(move, grid_map, next_pos)

        if moved? do
          {
            map_after_next_obstacle |> Map.delete(obstacle_pos) |> Map.put(next_pos, "O"),
            true
          }
        else
          {
            map_after_next_obstacle,
            false
          }
        end
    end
  end
end

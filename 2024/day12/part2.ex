defmodule Part2 do
  def solve do
    garden =
      "input.txt"
      |> File.stream!()
      |> Enum.map(&(String.trim(&1) |> String.graphemes()))

    nrows = length(garden)
    ncols = Enum.at(garden, 0) |> length()

    areas_ets = :ets.new(:areas, [:bag, :public])

    for i <- 0..(nrows - 1),
        j <- 0..(ncols - 1) do
      get_areas(garden, {i, j}, :ets.new(:visited, [:set, :public]), areas_ets, nrows, ncols)
    end

    areas =
      areas_ets
      |> :ets.tab2list()
      |> Enum.map(fn {_tabname, area} -> area end)
      |> Enum.uniq()

    areas
    |> Enum.map(fn area ->
      {area_size, perimeter} =
        area
        |> Enum.reduce({0, []}, fn {i, j}, {acc_area, acc_perimeter} ->
          directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]

          curr_perimeter =
            directions
            |> Enum.reduce(acc_perimeter, fn [di, dj], acc ->
              if not MapSet.member?(area, {i + di, j + dj}) do
                acc1 = [{i + di * 0.5, j + dj * 0.5, di * 0.5, dj * 0.5} | acc]

                cond do
                  di != 0 ->
                    [
                      {i + di * 0.5, j + 1 * 0.5, di * 0.5, 0.5}
                      | [{i + di * 0.5, j - 1 * 0.5, di * 0.5, -0.5} | acc1]
                    ]

                  dj != 0 ->
                    [
                      {i + 1 * 0.5, j + dj * 0.5, 0.5, dj * 0.5}
                      | [{i - 1 * 0.5, j + dj * 0.5, -0.5, dj * 0.5} | acc1]
                    ]

                  true ->
                    acc1
                end
              else
                acc
              end
            end)

          {acc_area + 1, curr_perimeter}
        end)
        |> then(fn {left, right} -> {left, right |> Enum.uniq()} end)

      perimeter_mapset =
        perimeter
        |> Enum.map(fn {y, x, _di, _dj} -> {y, x} end)
        |> MapSet.new()

      corners =
        get_corners(
          [],
          perimeter_mapset,
          perimeter
        )
        |> Enum.reduce(%{}, fn {y, x, neighbours}, acc ->
          acc
          |> Map.update({y, x}, [neighbours], fn vals -> [neighbours | vals] end)
        end)

      corners_size =
        corners
        |> Map.values()
        |> Enum.flat_map(fn [head | tail] ->
          if head == 2 do
            [head]
          else
            [head | tail]
          end
        end)
        |> length()

      area_size * corners_size
    end)
    |> Enum.sum()
  end

  defp get_corners(corners, _perimeter_mapset, []), do: corners

  defp get_corners(
         corners,
         perimeter_mapset,
         [{y, x, _di, _dj} | perimeter_tail]
       ) do
    directions = [[-0.5, 0], [0, 0.5], [0.5, 0], [0, -0.5]]

    neighbours =
      directions
      |> Enum.filter(fn [dy, dx] ->
        MapSet.member?(perimeter_mapset, {y + dy, x + dx})
      end)
      |> MapSet.new()

    colinear_neighbours =
      (MapSet.member?(neighbours, [-0.5, 0]) and MapSet.member?(neighbours, [0.5, 0])) or
        (MapSet.member?(neighbours, [0, -0.5]) and MapSet.member?(neighbours, [0, 0.5]))

    curr_corners =
      if not colinear_neighbours or MapSet.size(neighbours) == 4,
        do: [{y, x, neighbours |> MapSet.size()} | corners],
        else: corners

    curr_corners
    |> get_corners(perimeter_mapset, perimeter_tail)
  end

  defp get_areas(garden, {y, x}, visited, areas, nrows, ncols) do
    if :ets.lookup(visited, {y, x}) == [] do
      val = garden |> Enum.at(y) |> Enum.at(x)

      area =
        get_area(
          :queue.in({y, x}, :queue.new()),
          val,
          visited,
          MapSet.new(),
          garden,
          nrows,
          ncols
        )

      :ets.insert(areas, {:area, area})
    end
  end

  defp get_area(queue, val, visited, area, garden, nrows, ncols) do
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]

    case :queue.out(queue) do
      {:empty, _queue} ->
        area

      {{:value, {cy, cx}}, queue} ->
        if :ets.lookup(visited, {cy, cx}) == [] do
          :ets.insert(visited, {{cy, cx}, true})
          curr_area = MapSet.put(area, {cy, cx})

          neighbors =
            directions
            |> Enum.map(fn [dy, dx] -> {cy + dy, cx + dx} end)
            |> Enum.filter(fn {ny, nx} ->
              ny >= 0 and ny < nrows and nx >= 0 and nx < ncols and
                :ets.lookup(visited, {ny, nx}) == [] and
                Enum.at(Enum.at(garden, ny), nx) == val
            end)

          curr_queue =
            neighbors
            |> Enum.reduce(queue, fn nyx, acc -> :queue.in(nyx, acc) end)

          get_area(curr_queue, val, visited, curr_area, garden, nrows, ncols)
        else
          get_area(queue, val, visited, area, garden, nrows, ncols)
        end
    end
  end
end

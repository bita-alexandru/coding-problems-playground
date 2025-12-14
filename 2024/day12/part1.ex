defmodule Part1 do
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
      {area_size, perimeter_size} =
        area
        |> Enum.reduce({0, 0}, fn {i, j}, {acc_area, acc_perimeter} ->
          directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]

          curr_perimeter =
            Enum.count(directions, fn [di, dj] ->
              not MapSet.member?(area, {i + di, j + dj})
            end)

          {acc_area + 1, acc_perimeter + curr_perimeter}
        end)

      area_size * perimeter_size
    end)
    |> Enum.sum()
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

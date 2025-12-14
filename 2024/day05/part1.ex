defmodule Part1 do
  def solve do
    [rules, updates] =
      File.read!("input.txt")
      |> String.split("\r\n\r\n")
      |> Enum.map(&String.split(&1))

    priorities =
      rules
      |> Enum.reduce(%{}, fn rule, map ->
        [left, right] = String.split(rule, "|")
        Map.update(map, left, [right], &[right | &1])
      end)
      |> Enum.map(fn {key, val} ->
        {key, MapSet.new(val)}
      end)
      |> Map.new()

    ordered_updates =
      updates
      |> Enum.map(&String.split(&1, ","))
      |> Enum.reduce([], fn update, tail ->
        {_, ordered?} =
          Enum.reduce_while(update, {MapSet.new(), 1}, fn page, {prev_pages, ordered} ->
            intersection =
              MapSet.intersection(prev_pages, Map.get(priorities, page, MapSet.new()))

            if MapSet.size(intersection) > 0,
              do: {:halt, {MapSet.put(prev_pages, page), 0}},
              else: {:cont, {MapSet.put(prev_pages, page), ordered}}
          end)

        if ordered? == 1, do: [update | tail], else: tail
      end)

    ordered_updates
    |> Enum.map(fn update ->
      middle = div(length(update), 2)

      Enum.at(update, middle)
      |> String.to_integer()
    end)
    |> Enum.sum()
  end
end

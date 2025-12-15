defmodule Part2 do
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

    unordered_updates =
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

        if ordered? == 0, do: [update | tail], else: tail
      end)

    make_corrections = fn self, corrected?, current_updates ->
      if corrected? == 1 do
        current_updates
      else
        {revised_updates, oks?} =
          Enum.reduce(current_updates, {[], []}, fn update, {corrections, oks} ->
            {revised_update, ok?} =
              Enum.reduce(update, {[], 1}, fn page, {prev_pages, ok?} ->
                prev_pages_mapset = MapSet.new(prev_pages)

                intersection =
                  MapSet.intersection(prev_pages_mapset, Map.get(priorities, page, MapSet.new()))

                if MapSet.size(intersection) > 0 do
                  invalid_page = MapSet.to_list(intersection) |> Enum.at(0)
                  invalid_idx = Enum.find_index(prev_pages, &(&1 == invalid_page))
                  left_slice = Enum.slice(prev_pages, 0, invalid_idx)

                  right_slice =
                    Enum.slice(prev_pages, invalid_idx + 1, length(prev_pages))

                  corrected_update = left_slice ++ [page] ++ right_slice ++ [invalid_page]

                  {corrected_update, 0}
                else
                  {prev_pages ++ [page], ok?}
                end
              end)

            {[revised_update | corrections], [ok? | oks]}
          end)

        self.(
          self,
          if(Enum.all?(oks?, &(&1 == 1)), do: 1, else: 0),
          revised_updates
        )
      end
    end

    make_corrections.(make_corrections, 0, unordered_updates)
    |> Enum.map(fn update ->
      middle = div(length(update), 2)

      Enum.at(update, middle)
      |> String.to_integer()
    end)
    |> Enum.sum()
  end
end

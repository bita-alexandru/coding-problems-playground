defmodule Part2 do
  def solve do
    corrupted_memory = File.read!("input.txt")

    mul_matches =
      ~r/mul\((\d{1,3}),(\d{1,3})\)/
      |> Regex.scan(corrupted_memory)
      |> Enum.flat_map(fn [_mul, x, y] -> [String.to_integer(x) * String.to_integer(y)] end)

    mul_indexes =
      ~r/mul\(\d{1,3},\d{1,3}\)/
      |> Regex.scan(corrupted_memory, return: :index)
      |> Enum.flat_map(fn [{start, _size}] -> [start] end)

    dos_indexes =
      ~r/do\(\)/
      |> Regex.scan(corrupted_memory, return: :index)
      |> Enum.flat_map(fn [{start, _size}] -> [{start, "DO"}] end)

    donts_indexes =
      ~r/don't\(\)/
      |> Regex.scan(corrupted_memory, return: :index)
      |> Enum.flat_map(fn [{start, _size}] -> [{start, "DONT"}] end)

    rules =
      Enum.concat(dos_indexes, donts_indexes)
      |> Enum.sort()

    {_, _, sum} =
      Enum.zip(mul_indexes, mul_matches)
      |> Enum.reduce({"DO", rules, 0}, fn {idx, mul}, {curr_rule, curr_rules, sum} ->
        case curr_rules do
          [] ->
            {curr_rule, curr_rules, if(curr_rule == "DO", do: sum + mul, else: sum)}

          [{next_idx, next_rule} | next_rules] when idx >= next_idx ->
            {next_rule, next_rules, if(next_rule == "DO", do: sum + mul, else: sum)}

          _ ->
            {curr_rule, curr_rules, if(curr_rule == "DO", do: sum + mul, else: sum)}
        end
      end)

    sum
  end
end

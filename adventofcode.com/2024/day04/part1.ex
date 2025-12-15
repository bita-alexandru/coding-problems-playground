defmodule Part1 do
  def solve do
    xmas =
      File.read!("input.txt")
      |> String.split()
      |> Enum.map(&String.graphemes/1)

    xmas_transposed = xmas |> Enum.zip() |> Enum.map(&Tuple.to_list(&1))

    nrows = length(xmas)
    ncols = length(Enum.at(xmas, 0))

    diagonals_extractor = fn grid, {row_start, row_stop}, {col_start, col_stop} ->
      sign_col = if col_start < col_stop, do: 1, else: -1
      sign_row = if row_start < row_stop, do: 1, else: -1

      Enum.reduce(col_start..col_stop, [], fn col, diagonals ->
        {_, diagonal} =
          Enum.reduce_while(row_start..row_stop, {col, ""}, fn curr_row, {curr_col, diagonal} ->
            case {sign_col, sign_row} do
              {1, 1} when curr_col >= col_stop or curr_row >= row_stop ->
                {:halt, {curr_col, diagonal}}

              {1, -1} when curr_col >= col_stop or curr_row < row_stop ->
                {:halt, {curr_col, diagonal}}

              {-1, 1} when curr_col < col_stop or curr_row >= row_stop ->
                {:halt, {curr_col, diagonal}}

              {-1, -1} when curr_col < col_stop or curr_row < row_stop ->
                {:halt, {curr_col, diagonal}}

              _ ->
                char =
                  grid
                  |> Enum.at(curr_row)
                  |> Enum.at(curr_col)

                {:cont, {curr_col + sign_col, diagonal <> char}}
            end
          end)

        if String.length(diagonal) >= 4,
          do: [diagonal | [String.reverse(diagonal) | diagonals]],
          else: diagonals
      end)
    end

    diagonals_lr = diagonals_extractor.(xmas, {0, nrows}, {0, ncols})
    diagonals_rl = diagonals_extractor.(xmas, {0, nrows}, {ncols - 1, 0})
    diagonals_lr_transposed = diagonals_extractor.(xmas_transposed, {0, ncols}, {1, nrows})
    diagonals_rl_transposed = diagonals_extractor.(xmas_transposed, {ncols - 1, 0}, {1, nrows})

    rows_extractor = fn grid ->
      Enum.flat_map(grid, fn row ->
        [List.to_string(row), List.to_string(Enum.reverse(row))]
      end)
    end

    rows_normal = rows_extractor.(xmas)
    rows_transposed = rows_extractor.(xmas_transposed)

    all =
      rows_normal ++
        rows_transposed ++
        diagonals_lr ++ diagonals_rl ++ diagonals_lr_transposed ++ diagonals_rl_transposed

    all
    |> Enum.map(&(length(String.split(&1, "XMAS")) - 1))
    |> Enum.sum()
  end
end

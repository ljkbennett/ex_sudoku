defmodule ExSudoku.Board do
  def cell(board, {x, y}) do
    row(board, y)
    |> Enum.at(x)
  end

  def rows(board), do: board

  def row(board, y) do
    Enum.at(board, y)
  end

  def cols(board) do
    for x <- 0..8, do: col(board, x)
  end

  def col(board, x) do
    Enum.map(board, fn(row) -> Enum.at(row, x) end)
  end

  def squares(board) do
    for y <- 0..2,
        x <- 0..2,
        do: square(board, {x*3, y*3})
  end

  def square(board, {x, y}) do
    min_x = div(x, 3)*3
    min_y = div(y, 3)*3
    for y_pos <- min_y..min_y+2,
        x_pos <- min_x..min_x+2,
        do: cell(board, {x_pos, y_pos})
  end

  def empty?(val), do: val == 0
  def all_unique?(segment), do: Enum.all?(segment, &vals_unique?/1)

  def vals_unique?(values) do
    filtered_values = Enum.filter(values, fn(x) -> x > 0 end)
    unique_filtered_values = Enum.uniq(filtered_values)
    Enum.count(filtered_values) == Enum.count(unique_filtered_values)
  end

  def valid?(board) do
    rows_valid?(board)
    && cols_valid?(board)
    && squares_valid?(board)
  end

  defp rows_valid?(board), do: all_unique?(rows(board))
  defp cols_valid?(board), do: all_unique?(cols(board))
  defp squares_valid?(board), do: all_unique?(squares(board))

  def next_empty(board) do
    case Enum.find_index(rows(board), fn(row) -> Enum.any?(row, &empty?/1) end) do
      nil -> {:no_empty}
      y   -> {:ok, {Enum.find_index(row(board, y), &empty?/1), y}}
    end
  end

  def set_val(board, {x, y}, val) do
    new_row = row(board, y)
            |> List.replace_at(x, val)
    List.replace_at(board, y, new_row)
  end
end

defmodule ExSudoku.Solver do
  alias ExSudoku.Board

  def solve(board) do    
    Task.async(fn ->
      try do
        solve_process(board)
      catch :exit, {:solved, result} ->
        {:solved, result}
      end
    end)
    |> Task.await(:infinity)
  end

  def solve_process(board) do
    unless Board.valid?(board), do: exit(:invalid_board)
    
    Board.next_empty(board) 
    |> case do
      {:no_empty}   -> exit({:solved, board})
      {:ok, coords} -> next_generation(board, coords)
    end
  end

  defp next_generation(board, coords) do
    Process.flag(:trap_exit, true)

    children = for val <- 1..9 do
      board = Board.set_val(board, coords, val)
      spawn_link(__MODULE__, :solve_process, [board])
    end

    receive do
      {:EXIT, _, {:solved, board}} -> exit({:solved, board})
      {:EXIT, pid, {:invalid_board}} ->
        if Enum.all?(children, fn({:ok, pid}) -> !Process.alive?(pid) end) do
          exit(:invalid_board)
        end
    end
  end
end

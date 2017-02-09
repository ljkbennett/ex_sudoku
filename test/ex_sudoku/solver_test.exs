defmodule ExSudoku.SolverTest do
  use ExUnit.Case

  alias ExSudoku.Solver

  defp setup_completed_board(_) do
    example_board = [
      [1,2,3, 4,5,6, 7,8,9],
      [7,8,9, 1,2,3, 4,5,6],
      [4,5,6, 7,8,9, 1,2,3],
      
      [2,3,1, 5,6,4, 8,9,7],
      [8,9,7, 2,3,1, 5,6,4],
      [5,6,4, 8,9,7, 2,3,1],
      
      [3,1,2, 6,4,5, 9,7,8],
      [9,7,8, 3,1,2, 6,4,5],
      [6,4,5, 9,7,8, 3,1,2]
    ]

    {:ok, completed_board: example_board}
  end

  defp setup_nearly_complete_board(_) do
   example_board = [
      [1,2,3, 4,5,6, 7,8,9],
      [7,8,9, 1,2,3, 4,5,6],
      [4,5,6, 7,8,9, 1,2,3],
      
      [2,3,1, 5,6,4, 8,9,7],
      [8,9,7, 2,3,1, 5,6,4],
      [5,6,4, 8,9,7, 2,3,1],
      
      [3,1,2, 6,4,5, 9,7,8],
      [9,7,8, 3,1,2, 6,4,5],
      [6,4,5, 9,7,8, 3,1,0]
    ]

    {:ok, incomplete_board: example_board}
  end

  defp setup_incomplete_board(_) do
    example_board = [
      [8,3,0, 1,0,0, 6,0,5],
      [0,0,0, 0,0,0, 0,8,0],
      [0,0,0, 7,0,0, 9,0,0],

      [0,5,0, 0,1,7, 0,0,0],
      [0,0,3, 0,0,0, 2,0,0],
      [0,0,0, 3,4,0, 0,1,0],

      [0,0,4, 0,0,8, 0,0,0],
      [0,9,0, 0,0,0, 0,0,0],
      [3,0,2, 0,0,6, 0,4,7]
    ]

    completed_board = [
      [8,3,7, 1,9,4, 6,2,5],
      [5,4,9, 6,2,3, 7,8,1],
      [6,2,1, 7,8,5, 9,3,4],

      [2,5,6, 8,1,7, 4,9,3],
      [4,1,3, 5,6,9, 2,7,8],
      [9,7,8, 3,4,2, 5,1,6],
      
      [1,6,4, 2,7,8, 3,5,9],
      [7,9,5, 4,3,1, 8,6,2],
      [3,8,2, 9,5,6, 1,4,7]
    ]
    
    {:ok, incomplete_board: example_board, completed_board: completed_board}
  end

  describe ".solve/1 with a completed board" do
    setup :setup_completed_board

    test "it returns a solved tuple",%{completed_board: board} do
      assert Solver.solve(board) === {:solved, board}
    end
  end

  describe ".solve/1 with one step left" do
    setup [:setup_nearly_complete_board, :setup_completed_board]

    @tag timeout: :infinity
    test "it returns a solved tuple", %{completed_board: complete, incomplete_board: board} do
      assert Solver.solve(board) === {:solved, complete}
    end
  end

  describe ".solve/1 with lots of steps left" do
    setup [:setup_incomplete_board]

    @tag timeout: :infinity
    test "it returns a solved tuple", %{completed_board: complete, incomplete_board: board} do
      assert Solver.solve(board) === {:solved, complete}
    end
  end
end
defmodule ExSudoku.BoardTest do
  use ExUnit.Case

  alias ExSudoku.Board

  defp setup_board(_) do
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
    {:ok, board: example_board}
  end

  defp setup_completed_valid_board(_) do
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

    {:ok, board: example_board}
  end

  defp setup_completed_invalid_board(_) do
    example_board = [
      [1,1,1, 1,1,1, 1,1,1],
      [2,2,2, 2,2,2, 2,2,2],
      [3,3,3, 3,3,3, 3,3,3],
      
      [4,4,4, 4,4,4, 4,4,4],
      [5,5,5, 5,5,5, 5,5,5],
      [6,6,6, 6,6,6, 6,6,6],
      
      [7,7,7, 7,7,7, 7,7,7],
      [8,8,8, 8,8,8, 8,8,8],
      [9,9,9, 9,9,9, 9,9,9]
    ]

    {:ok, board: example_board}
  end
  
  describe ".squares/1" do
    setup :setup_board
    test "gets all the squares from the board", %{board: board} do
      squares = Board.squares(board)
      assert squares === [
        [8,3,0,0,0,0,0,0,0],
        [1,0,0,0,0,0,7,0,0],
        [6,0,5,0,8,0,9,0,0],
        [0,5,0,0,0,3,0,0,0],
        [0,1,7,0,0,0,3,4,0],
        [0,0,0,2,0,0,0,1,0],
        [0,0,4,0,9,0,3,0,2],
        [0,0,8,0,0,0,0,0,6],
        [0,0,0,0,0,0,0,4,7]
      ]
    end
  end

  describe ".rows/1" do
    setup :setup_board
    test "gets all the rows from the board", %{board: board} do
      rows = Board.rows(board)
      assert rows === [
        [8,3,0,1,0,0,6,0,5],
        [0,0,0,0,0,0,0,8,0],
        [0,0,0,7,0,0,9,0,0],
        [0,5,0,0,1,7,0,0,0],
        [0,0,3,0,0,0,2,0,0],
        [0,0,0,3,4,0,0,1,0],
        [0,0,4,0,0,8,0,0,0],
        [0,9,0,0,0,0,0,0,0],
        [3,0,2,0,0,6,0,4,7]
      ]
    end
  end

  describe ".cols/1" do
    setup :setup_board
    test "gets all the columns from the board", %{board: board} do
      cols = Board.cols(board)
      assert cols === [
        [8,0,0,0,0,0,0,0,3],
        [3,0,0,5,0,0,0,9,0],
        [0,0,0,0,3,0,4,0,2],
        [1,0,7,0,0,3,0,0,0],
        [0,0,0,1,0,4,0,0,0],
        [0,0,0,7,0,0,8,0,6],
        [6,0,9,0,2,0,0,0,0],
        [0,8,0,0,0,1,0,0,4],
        [5,0,0,0,0,0,0,0,7]
      ]
    end
  end

  describe ".vals_unique?/1" do
    test "returns true if all values are unique" do
      assert Board.vals_unique?([1,2,3]) === true
    end

    test "returns false if values are repeated" do
      assert Board.vals_unique?([1,2,2]) === false
    end

    test "ignores repeated zeroes" do
      assert Board.vals_unique?([1,0,0]) === true
    end
  end

  describe ".all_unique?/1" do
    test "returns true if all values in all segments are unique" do
      assert Board.all_unique?([[1,2,3],[1,2,3]]) === true
    end

    test "returns false if values are repeated" do
      assert Board.all_unique?([[1,2,3],[1,2,2]]) === false
    end

    test "ignores repeated zeroes" do
      assert Board.all_unique?([[1,0,0],[1,0,0]]) === true
    end
  end

  describe ".empty?/1" do
    test "is empty if value is 0" do
      assert Board.empty?(0) === true
    end

    test "is not empty if value is not 0" do
      assert Board.empty?(1) === false
    end
  end

  describe ".next_empty/1" do
    test "is no values are empty" do
      assert Board.next_empty([[1,2,3],[4,5,6]]) === {:no_empty}
    end

    test "if value is empty it returns the coordinates" do
      assert Board.next_empty([[1,2,3],[4,0,6]]) === {:ok, {1,1}}
    end
  end

  describe ".valid?/1 with a valid board" do
    setup :setup_completed_valid_board
    test "returns true", %{board: board} do
      assert Board.valid?(board) === true
    end
  end

  describe ".valid?/1 with an invalid board" do
    setup :setup_completed_invalid_board
    test "returns false", %{board: board} do
      assert Board.valid?(board) === false
    end
  end

  describe ".set_val/3" do
    setup :setup_completed_invalid_board
    test "creates a new board with the new value", %{board: board} do
      assert Board.set_val(board, {1, 1}, 5) === [
        [1,1,1, 1,1,1, 1,1,1],
        [2,5,2, 2,2,2, 2,2,2],
        [3,3,3, 3,3,3, 3,3,3],
        
        [4,4,4, 4,4,4, 4,4,4],
        [5,5,5, 5,5,5, 5,5,5],
        [6,6,6, 6,6,6, 6,6,6],
        
        [7,7,7, 7,7,7, 7,7,7],
        [8,8,8, 8,8,8, 8,8,8],
        [9,9,9, 9,9,9, 9,9,9]
      ]
    end
  end
end

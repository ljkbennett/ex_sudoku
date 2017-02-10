# ExSudoku
To run the tests: `mix test`

To solve a sudoku:
* build the board as a list of lists, with a 0 representing each empty square, e.g.:
  ```
    board = [
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
  ```
* solve the board with the command: `ExSudoku.Solver.solve(board)`


TODO:
* accept a string input
* output results
* read inputs from https://projecteuler.net/project/resources/p096_sudoku.txt

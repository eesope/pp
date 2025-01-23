(* Eight queens problem: 
objective is to place eight queens on a chessboard so that no two queens are attacking each other; 
i.e., no two queens are in the same row, the same column, or on the same diagonal. *)

(* [queens_posit n] returns int list of lists represents positions of queens in the grid; index is column# & value is row# *)

(* 
- set max possible queens 
- put first queen on row1 upon total# of queens
- brute force || backtracking tree
*)








(* Nonograms:お絵かきロジック　https://ja.wikipedia.org/wiki/%E3%81%8A%E7%B5%B5%E3%81%8B%E3%81%8D%E3%83%AD%E3%82%B8%E3%83%83%E3%82%AF
each row and column of a rectangular bitmap is annotated with the respective lengths of its distinct strings of occupied cells. 
The person who solves the puzzle must complete the bitmap given only these lengths.
Problem statement:          Solution:

          |_|_|_|_|_|_|_|_| 3         |_|X|X|X|_|_|_|_| 3
          |_|_|_|_|_|_|_|_| 2 1       |X|X|_|X|_|_|_|_| 2 1
          |_|_|_|_|_|_|_|_| 3 2       |_|X|X|X|_|_|X|X| 3 2
          |_|_|_|_|_|_|_|_| 2 2       |_|_|X|X|_|_|X|X| 2 2
          |_|_|_|_|_|_|_|_| 6         |_|_|X|X|X|X|X|X| 6
          |_|_|_|_|_|_|_|_| 1 5       |X|_|X|X|X|X|X|_| 1 5
          |_|_|_|_|_|_|_|_| 6         |X|X|X|X|X|X|_|_| 6
          |_|_|_|_|_|_|_|_| 1         |_|_|_|_|X|_|_|_| 1
          |_|_|_|_|_|_|_|_| 2         |_|_|_|X|X|_|_|_| 2
          1 3 1 7 5 3 4 3             1 3 1 7 5 3 4 3
          2 1 5 1                     2 1 5 1
*)
(* some variant/sum types *)
type direction = North | East | South | West

(* our own option type *)
type 'a option' = None' | Some' of 'a

let sqrt x =
  if x >= 0. then Some' (Stdlib.sqrt x)
  else None'

(* our own result type *)
type ('a, 'b) result' = Ok' of 'a | Error' of 'b

(* e.g. Ok' 1; Error' "file does not exist" *)

type expr =
  | Int of int
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr

let rec eval e =
  match e with
  | Int n -> n
  | Add (e1, e2) -> eval e1 + eval e2
  | Sub (e1, e2) -> eval e1 - eval e2
  | Mul (e1, e2) -> eval e1 * eval e2

let ( ++ ) e1 e2 = Add (e1, e2)
let ( -- ) e1 e2 = Sub (e1, e2)
let ( ** ) e1 e2 = Mul (e1, e2)

let e = Int 1 ++ (Int 2 ** Int 3)
(* try: eval e *)

(* list type *)
type 'a mylist = Nil | Cons of 'a * 'a mylist

(* some sample functions that we can implement for the mylist type *)
let hd l =
  match l with
  | Nil -> failwith "hd: empty list"
  | Cons (x, _) -> x

let rec length l =
  match l with
  | Nil -> 0
  | Cons (_, xs) -> 1 + length xs

let rec map f l =
  match l with
  | Nil -> Nil
  | Cons (x, xs) -> Cons (f x, map f xs)

(* try: map (( * ) 2) @@ Cons (1, Cons (2, Cons (3, Nil))) *)


(** [length l] returns the length (the number of elements) of the list [l] *) 
let rec length l =
  match l with
  | [] -> 0
  | _ :: xs -> 1 + length xs

let rec length_aux acc l =
  match l with
  | [] -> acc
  | _ :: xs -> length_aux (acc + 1) xs

let length_tr l = length_aux 0 l

(** [reverse l] returns a list consisting of the elements of [l] in 
    reverse order *)
let reverse l =
  let rec aux l acc =
    match l with
    | [] -> acc
    | x :: xs -> aux xs (x :: acc)
  in
  aux l []

let test_reverse () =
  assert(reverse [1;2;3] = [3;2;1]);
  assert(reverse [] = [])

(** [equal eq [a1; ...; an] [b1; ..; bm]] holds when the two input lists
    have the same length, and for each pair of elements [ai], [bi] at the
    same position we have [eq ai bi]. *)
let rec equal eq l1 l2 =
  match l1, l2 with
  | [], [] -> true
  | _, [] | [], _ -> false
  | x1 :: xs1, x2 :: xs2 ->
    eq x1 x2 && equal eq xs1 xs2

(* let eq = (=) *)

(** [alternate l] returns a list consisting of every other element of [l],
    starting from the first element *)
let rec alternate l = 
  match l with
  | x1 :: x2 :: xs -> x1 :: alternate xs
  | _ -> l


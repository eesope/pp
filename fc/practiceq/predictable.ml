type 'a t = Leaf | Node of ('a * 'a t * 'a t)

let empty = Leaf

let rec insert x tree =
  match tree with
  | Leaf -> Node (x, Leaf, Leaf)
  | Node (v, l, r) when v > x -> Node (v, (insert x l), r)
  | Node (v, l, r) when v < x -> Node (v, l, (insert x r))
  | _ -> tree 

let tree = empty |> insert 5 |> insert 3 |> insert 1 |> insert 4 |> insert 6

let left_right tree =
  match tree with
  | Leaf | Node (_, Leaf, _) -> None
  | Node (_, l, _) -> 
    match l with
    | Leaf | Node (_, _, Leaf) -> None
    | Node (_, _, r) -> Some r
    

let result = left_right tree
let () = match result with
  | None -> print_endline "No right child"
  | Some t -> print_endline "Right child found"

let dup str n =
  let rec aux str n acc =
    if n <= 0 then acc
    else aux str (n-1) (str^" "^acc)
  in aux str n ""

let fact_tr n =
  let rec aux n acc =
    if n = 1 then acc 
    else aux (n-1) (n*acc)
  in aux n 1;;
(* compile using: ocamlbuild bstree.cmo
 * to load in utop, type:
 * #directory "_build";;
 * #load "bstree.cmo";;
 * you can call a function like this: Bstree.is_empty 
 *) 
type 'a t = Leaf | Node of 'a * 'a t* 'a t

let empty = Leaf

let is_empty t = t = Leaf

let rec size t =
  match t with
  | Leaf -> 0
  | Node (_, l, r) -> 1 + size l + size r

let rec height t =
  match t with
  | Leaf -> 0
  | Node (_, l, r) -> 1 + max (height l) (height r)

let rec insert z t =
  match t with
  | Leaf -> Node (z, Leaf, Leaf)
  | Node (x, l, r) when z < x ->
    Node (x, insert z l, r)
  | Node (x, l, r) when z > x ->
    Node (x, l, insert z r)
  | _ -> t

let of_list l =
  List.fold_left (Fun.flip insert) empty l

let rec largest t =
  match t with
  | Leaf -> failwith "largest: empty tree"
  | Node (x, _, Leaf) -> x
  | Node (_, _, r) -> largest r

let rec delete z t =
  match t with
  | Leaf -> Leaf
  | Node (x, l, r) when z < x ->
    Node (x, delete z l, r)
  | Node (x, l, r) when z > x ->
    Node (x, l, delete z r)
  | Node (_, Leaf, r) -> r
  | Node (_, l, Leaf) -> l
  | Node (_, l, r) ->
    let max = largest l in
    Node (max, delete max l, r)

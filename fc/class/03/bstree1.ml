type 'a bstree = Leaf | Node of 'a * 'a bstree * 'a bstree

let bstree_empty = Leaf

let bstree_is_empty t = t = Leaf

let rec bstree_size t =
  match t with
  | Leaf -> 0
  | Node (_, l, r) -> 1 + bstree_size l + bstree_size r

let rec bstree_height t =
  match t with
  | Leaf -> 0
  | Node (_, l, r) -> 1 + max (bstree_height l) (bstree_height r)

let rec bstree_insert z t =
  match t with
  | Leaf -> Node (z, Leaf, Leaf)
  | Node (x, l, r) when z < x ->
    Node (x, bstree_insert z l, r)
  | Node (x, l, r) when z > x ->
    Node (x, l, bstree_insert z r)
  | _ -> t

let bstree_of_list l =
  List.fold_left (Fun.flip bstree_insert) bstree_empty l

let rec bstree_largest t =
  match t with
  | Leaf -> failwith "bstree_largest: empty tree"
  | Node (x, _, Leaf) -> x
  | Node (_, _, r) -> bstree_largest r

let rec bstree_delete z t =
  match t with
  | Leaf -> Leaf
  | Node (x, l, r) when z < x ->
    Node (x, bstree_delete z l, r)
  | Node (x, l, r) when z > x ->
    Node (x, l, bstree_delete z r)
  | Node (_, Leaf, r) -> r
  | Node (_, l, Leaf) -> l
  | Node (_, l, r) ->
    let max = bstree_largest l in
    Node (max, bstree_delete max l, r)

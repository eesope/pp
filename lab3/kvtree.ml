type ('k, 'v) t = Leaf | Node of 'k * 'v * ('k, 'v) t * ('k, 'v) t

(* returns empty tree *)
let empty = Leaf

(* [is_empty t] returns boolean value by checking 
whether the given tree is empty or not *)
let is_empty t = 
  t = Leaf

(* [size t] returns the size of tree (number of nodes) *)
let rec size t =
  match t with
  | Leaf -> 0
  | Node (k, v, l, r) -> 1 + size l + size r

(* [insert k v t] returns new key-value, if
the key is already in the tree, update the value *)
let rec insert k v t =
  match t with
  | Leaf -> Node (k, v, Leaf, Leaf)
  | Node (xk, xv, l, r) when k < xk -> 
    Node (xk, xv, (insert k v l ), r)
  | Node (xk, xv, l, r) when k > xk -> 
    Node (xk, xv, l, (insert k v r))
  | Node (_, _, l, r) -> Node (k, v, l, r)

(* [find k t] returns value if the key is found, 
None for key not found *)
let rec find k t =
  match t with
  | Leaf -> None
  | Node (xk, v, l, r) when xk = k -> Some v  
  | Node (xk, v, l, r) when xk < k -> find k r
  | Node (xk, v, l, r) when xk > k -> find k l
  | _ -> None

(* [largest t] returns largest key-value pair *)
let rec largest t = 
  match t with
  | Leaf -> failwith "largest: empty tree"
  | Node (k, v, _, Leaf) -> (k, v)
  | Node (k, v, _, r) -> largest r 

(* [delete z t] returns tree after delting the node of given key *)
let rec delete z t =
  match t with
  | Leaf -> Leaf
  | Node (k, v, l, r) when z < k ->
    Node (k, v, delete z l, r)
  | Node (k, v, l, r) when z > k ->
    Node (k, v, l, delete z r)
  | Node (_, _, Leaf, r) -> r
  | Node (_, _, l, Leaf) -> l
  | Node (_, _, l, r) ->
    let (max_k, max_v) = largest l in
    Node (max_k, max_v, delete max_k l, r) 

(* [of_list lst] returns tree after making one 
from the key-value pair in the given list *)
let of_list lst = 
  List.fold_left (fun t (k, v) -> insert k v t) empty lst

let test_empty () =
  assert (empty = Leaf);
  assert (empty <> Node (1, "a", Leaf, Leaf));
  assert (empty = Leaf)

let test_is_empty () =
  assert (is_empty empty = true);
  assert (is_empty (Node (1, "a", Leaf, Leaf)) = false);
  assert (is_empty Leaf = true)

let test_size () =
  assert (size empty = 0);
  assert (size (Node (1, "a", Leaf, Leaf)) = 1);
  assert (size (Node (1, "a", Node (2, "b", Leaf, Leaf), Leaf)) = 2)

let test_insert () =
  let t = insert 1 "a" empty in
  assert (t = Node (1, "a", Leaf, Leaf));
  let t = insert 2 "b" t in
  assert (t = Node (1, "a", Leaf, Node (2, "b", Leaf, Leaf)));
  let t = insert 1 "updated" t in
  assert (t = Node (1, "updated", Leaf, Node (2, "b", Leaf, Leaf)))

let test_find () =
  let t = insert 1 "a" empty in
  let t = insert 2 "b" t in
  assert (find 1 t = Some "a");
  assert (find 2 t = Some "b");
  assert (find 3 t = None)

let test_largest () =
  let t = insert 1 "a" empty in
  let t = insert 2 "b" t in
  assert (largest t = (2, "b"));
  let t = insert 3 "c" t in
  assert (largest t = (3, "c"));
  let t = insert 0 "z" t in
  assert (largest t = (3, "c"))

let test_delete () =
  let t = insert 1 "a" empty in
  let t = insert 2 "b" t in
  let t = insert 3 "c" t in
  let t = delete 2 t in
  assert (find 2 t = None);
  let t = delete 1 t in
  assert (find 1 t = None);
  assert (find 3 t = Some "c")

let test_of_list () =
  let t = of_list [(1, "a"); (2, "b"); (3, "c")] in
  assert (find 1 t = Some "a");
  assert (find 2 t = Some "b");
  assert (find 3 t = Some "c")


let () =
  test_empty();
  test_is_empty();
  test_size();
  test_insert();
  test_find();
  test_largest();
  test_delete();
  test_of_list()

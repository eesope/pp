type 'a t = L | N of {v: 'a; l: 'a t; r: 'a t}

let empty = L

let is_empty t = t = L

let rec size t =
  match t with
  | L -> 0
  | N {l; r} -> 1 + size l + size r

let rec insert x t =
  match t with
  | L -> N {v = x; l = L; r = L}
  | N {v; l; r} when x < v ->
    N {v; l = insert x l; r}
  | N {v; l; r} when x > v ->
    N {v; l; r = insert x r}
  | _ -> t

let of_list l =
  List.fold_left (Fun.flip insert) empty l

let rec mem x t =
  match t with
  | L -> false
  | N {v; l} when x < v -> mem x l
  | N {v; r} when x > v -> mem x r
  | _ -> true

let rec max t =
  match t with
  | L -> failwith "max: empty tree"
  | N {v; r = L} -> v
  | N {r} -> max r

let rec delete x t =
  match t with
  | L -> L
  | N {v; l; r} when x < v ->
    N {v; l = delete x l; r}
  | N {v; l; r} when x > v ->
    N {v; l; r = delete x r}
  | N {l = L; r} -> r
  | N {r = L; l} -> l
  | N {l; r} ->
    let m = max l in
    N {v = m; l = delete m l; r}

let rec stringify converter t =
  match t with
  | L -> "*"
  | N {v; l; r} ->
    "(" ^
    converter v ^
    "," ^
    stringify converter l ^
    "," ^
    stringify converter r ^
    ")"

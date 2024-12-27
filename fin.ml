(* 1. *)
type 'a lazystream = Cons of 'a * 'a lazystream Lazy.t

let rec take n (Cons (h, t)) =
    if n <= 0 then []
    else h :: take (n - 1) (Lazy.force t)

let rec from n = Cons (n, lazy (from (n + 1)))
let rec map f (Cons (h, t)) = Cons (f h, lazy (map f (Lazy.force t)))
let squares = map (fun x -> x * x) (from 1)

let rec map2 f (Cons (h1, t1)) (Cons (h2, t2)) =
    Cons (f h1 h2, lazy (map2 f (Lazy.force t1) (Lazy.force t2)))
let enumerate l = map2 (fun x y -> x, y) (from 1) l

(* 2 *)
type 'a btree = L | N of 'a * 'a btree * 'a btree

let rec map f t =
    match t with
    | L -> L
    | N (v, l, r) -> N (f v, map f l, map f r)

let rec count t =
    match t with
    | L -> 0
    | N (_, l, r) ->
        match l, r with
        | N (_), N (_) -> 1 + (count l) + (count r)
        | _, _ -> (count l) + (count r)

(* 3. *)
type 'a slist = E | N of {v: 'a; n: 'a slist}

let rec seq x y =
    if x > y then E
    else N {v = x; n = seq (x + 1) y}

let rec slist_of_list l =
    match l with
    | [] -> E
    | x :: xs -> N {v = x; n = slist_of_list xs}

(* shouldn't had used List.hd, tl... but the basic one! :: *)

let reverse s =
    let rec aux s acc =
        match s with
        | E -> acc
        | N {v; n} -> aux n (N {v; n = acc})
    in
    aux s E
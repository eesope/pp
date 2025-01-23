(* motivation for monads *)
type 'a t = L | N of 'a * 'a t * 'a t

let empty = L

let rec insert x t =
  match t with
  | L -> N (x, L, L)
  | N (v, l, r) ->
    if x < v then N (v, insert x l, r)
    else if x > v then N (v, l, insert x r)
    else t

let of_list l = List.fold_left (Fun.flip insert) empty l

let right t =
  match t with
  | L -> None
  | N (_, _, r) -> Some r

let right_left t =
  match t with
  | L -> None
  | N (_, _, r) ->
    match r with
    | L -> None
    | N (_, l, _) -> Some l

(* alternative implementation *)
let right_left' t =
  match right t with
  | None -> None
  | Some r -> 
    match r with
    | L -> None
    | N (_, l, _) -> Some l

let left t =
  match t with
  | L -> None
  | N (_, l, _) -> Some l

(* Maybe monad *)
let return x = Some x

let bind mx f =
  match mx with
  | None -> None
  | Some x -> f x

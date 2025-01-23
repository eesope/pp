(* since the largest function is not in here, it is hidden *)
type 'a t = Leaf | Node of 'a * 'a t * 'a t
val empty : 'a t
val is_empty : 'a t -> bool
val size : 'a t -> int
val height : 'a t -> int
val insert : 'a -> 'a t -> 'a t
val of_list : 'a list -> 'a t
val delete : 'a -> 'a t -> 'a t

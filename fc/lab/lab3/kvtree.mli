type ('k, 'v) t = Leaf | Node of 'k * 'v * ('k, 'v) t * ('k, 'v) t
val empty : ('a, 'b) t
val is_empty : ('a, 'b) t -> bool
val size : ('a, 'b) t -> int
val insert : 'a -> 'b -> ('a, 'b) t -> ('a, 'b) t
val find : 'a -> ('a, 'b) t -> 'b option
val delete : 'a -> ('a, 'b) t -> ('a, 'b) t
val of_list : ('a * 'b) list -> ('a, 'b) t

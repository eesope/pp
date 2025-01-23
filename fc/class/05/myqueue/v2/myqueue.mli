module type S = sig
  type 'a t
  exception Empty

  val empty : 'a t

  val is_empty : 'a t -> bool

  val enqueue : 'a -> 'a t -> 'a t

  val dequeue : 'a t -> 'a t

  val dequeue_opt : 'a t -> 'a t option

  val front : 'a t -> 'a

  val front_opt : 'a t -> 'a option

  val to_list : 'a t -> 'a list
end

module ListQueue : S 
module TwoListQueue : S 

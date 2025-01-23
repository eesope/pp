module type OrderedType = sig
  type t  (* 정렬할 때 사용할 요소의 타입을 정의 *)
  val compare : t -> t -> int  
  (* 두 요소 t 를 비교하여, 
  0 if t = t, 
  -1 if t < t, 
  1 if t > t
  *)
end

module type S = sig
  type elt  (* 원소 타입 *)
  type t  (* 트리 타입 *)

  val empty : t
  val is_empty : t -> bool
  val insert : elt -> t -> t
  val of_list : elt list -> t
  val delete : elt -> t -> t
  val mem : elt -> t -> bool
end

(* Make는 OrderedType을 사용하여 S 인터페이스를 구현, 트리 모듈을 생성하는 Functor 
-> 주어진 순서 정의(Ord)를 활용하여 이진 검색 트리 자료구조를 구성 *)
module Make (Ord : OrderedType) = struct  
  (* Ord 를 인자로 받아 그 안에 정의된 compare 함수로 트리 원소 정렬 *)
  
type elt = Ord.t  (* OrderedType 의 t 를 element 로써 사용 
  -> 추후 트리 연산 intert, delete, mem 에서 Ord.compare 를 사용, 트리 노드 순서 유지 
  -> Ord.compare 에 의존적 이므로 Functor 인 Make 를 사용하여 트리 구성 *)
  type t = Leaf | Node of elt * t * t

  let empty = Leaf

  let is_empty t = t = Leaf

  let rec insert x t =
    match t with
    | Leaf -> Node (x, Leaf, Leaf)
    | Node (x', l, r) when Ord.compare x x' < 0 ->
      Node (x', insert x l, r)
    | Node (x', l, r) when Ord.compare x x' > 0 ->
      Node (x', l, insert x r)
    | _ -> t  (* z = x 일 때 중복 요소 넣지 않고 t 를 그대로 반환 *)

  (* l 에 있는 모든 원소로 트리 생성 *)
  let of_list l =
    List.fold_left (Fun.flip insert) empty l  (* Fun.flip 이용 -> 위 정의한 insert x t 의 순서에 맞게 인자 전달 *)


  (* 가장 큰 값을 가진 노드의 원소를 반환 -> literally 제일 큰 원소 그 자체를 반환, root X *)
  let rec largest t =  
    match t with
    | Leaf -> failwith "largest: empty tree"
    | Node (x, _, Leaf) -> x
    | Node (_, _, r) -> largest r

  let rec delete z t =
    match t with
    | Leaf -> Leaf
    | Node (x, l, r) when Ord.compare z x < 0 ->
      Node (x, delete z l, r)
    | Node (x, l, r) when Ord.compare z x > 0 ->
      Node (x, l, delete z r)
    | Node (_, Leaf, r) -> r
    | Node (_, l, Leaf) -> l
    | Node (_, l, r) ->
      let max = largest l in
      Node (max, delete max l, r)

  let rec mem z t =
    match t with
    | Leaf -> false
    | Node (x, l, _) when Ord.compare z x < 0 ->
      mem z l
    | Node (x, _, r) when Ord.compare z x > 0 ->
      mem z r
    | _ -> true
end

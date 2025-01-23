module type S = sig
  type 'a t  (* 아래 ListQueue 와 TwoListQueue 에서 타입을 각 지정 가능토록 *)
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

module ListQueue = struct
  type 'a t = 'a list
  exception Empty

  let empty = []

  let is_empty q = q = []

  let enqueue x q = q @ [x]

  let dequeue = function
    | [] -> raise Empty
    | _ :: xs -> xs

  let dequeue_opt = function
    | [] -> None
    | _ :: xs -> Some xs

  let front = function
    | [] -> raise Empty
    | x :: _ -> x

  let front_opt = function
    | [] -> None
    | x :: _ -> Some x

  let to_list q = q
end

module TwoListQueue = struct
  type 'a t = 'a list * 'a list
  (* 
  'a list * 'a list 즉 (l, l') 로 큐를 구현
  첫 번째 리스트 (l)는 앞부분의 요소들을 저장하고, 큐의 dequeue와 front 연산에 사용
  두 번째 리스트 (l')는 뒤에서부터 요소를 추가하며 enqueue 연산에 사용
  *)

  exception Empty

  let empty = ([], [])

  let is_empty (l, _) = l = []  (* queue is empty iff first list is empty *)

  let enqueue x q =
    match q with
    | [], l -> [x], l  (* 큐가 비어있는 상태로 판단되어 앞 리스트에 원소 추가 *)
    | l, l' -> l, x :: l'  
    (* x 를 l' 앞에 추가 이유: l' 을 스택처럼 사용하기 위해 
    -> 추후 l 이 비었을 때, List.rev l' 을 하여 l 로써 사용 *)

    (* x @ l' 를 하면 O(n) 이 되어 비효율
    x :: l' 은 O(1) 이라 효율적 *)

    (* 이 모든 것은 구조상 
    l'을 반전하기 전까지 직접 사용하지 않기 때문에 가능 *)

  let dequeue q =
    match q with
    | [], _ -> raise Empty
    | [_], l -> List.rev l, []
    | _ :: xs, l -> xs, l

  let dequeue_opt q =
    match q with
    | [], _ -> None
    | [_], l -> Some (List.rev l, [])
    | _ :: xs, l -> Some (xs, l)

  let front = function
    | [], _ -> raise Empty
    | x :: _, _ -> x

  let front_opt = function
    | [], _ -> None
    | x :: _, l -> Some x

  let to_list (l, l') = l @ List.rev l'
end

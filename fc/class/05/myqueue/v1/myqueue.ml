type 'a t = 'a list
exception Empty

let empty = []

let is_empty q = q = []

let enqueue x q = q @ [x]
(* q 의 끝에 x 를 추가 *)
(* @ 는 리스트 끝에 요소 추가 *)
(* :: 는 리스트 앞에 요소 추가 *)
(* List.fold_left, fold_right 의 경우 앞에 추가 *)

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

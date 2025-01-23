let return x = Some x

let ( >>= ) mx f =
  match mx with
  | None -> None
  | Some x -> f x

let div a b =
  if b = 0 then None
  else Some (a / b)

(* how to make the square function work with options *)
let square mx = mx >>= fun x -> return (x * x)

(* e.g. square (div 6 2) returns Some 9 *)

let lift f mx = mx >>= fun x -> return (f x)

(* regular cube function *)
let cube x = x * x * x

let cube' = lift cube

let add mx my = 
  mx >>= fun x ->
  my >>= fun y ->
  return (x + y)

let lift2 f mx my =
  mx >>= fun x ->
  my >>= fun y ->
  return (f x y)

let ( + ) = lift2 Stdlib.( + )
let ( * ) = lift2 ( * )
let ( - ) = lift2 ( - )

let ( / ) mx my =
  mx >>= fun x ->
  my >>= fun y ->
  div x y


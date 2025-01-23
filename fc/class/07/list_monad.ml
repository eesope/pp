(* list monad *)
let return x = [x]

let ( >>= ) l f = List.concat_map f l

let ( let* ) = ( >>= )

let multiply_to n =
  List.init n ((+) 1) >>= fun x ->
    List.init n ((+) 1) >>= fun y ->
      if x * y = n then [(x, y)] else []

(* e.g. multiply_to 20 returns [(1, 20); (2, 10); (4, 5); (5, 4); (10, 2); (20, 1)] *)

let multiply_to' n =
  let* x = List.init n ((+) 1) in
  let* y = List.init n ((+) 1) in
  if x * y = n then [(x, y)] else []


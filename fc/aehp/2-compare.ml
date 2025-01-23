exception Division_by_zero
let risky_division x y =
  try Some (x / y) with 
  Division_by_zero -> None;;



open Effect
open Effect.Deep

type _ Effect.t += DivisionByZero : int Effect.t
let risky_division2 x y =
  if y = 0 then perform (DivisionByZero) else x / y

let handle_division division =
  let handler =
    { effc = fun (type a) (eff: a t) ->
        match eff with
        | DivisionByZero -> Some (fun (k: (a, _) continuation) ->
            continue k 0) 
        | _ -> None
    }
  in
  try_with division() handler

(* handle_division (fun () -> risky_division2 10 0);; *)


open Effect
open Effect.Deep

(* += expanding *)
(* Xchg effect takes int -> when effect is performed -> returns int *)
type _ Effect.t += Xchg: int -> int t

(* performs the effect Xchg twice -> 
  does not calculate the value exactly but operate the EFFECT *)
let computation1 () = perform (Xchg 0) + perform (Xchg 1) 

(* handler returns the next value *)
let () =
  let handler =  (* handler object *)
    {            (* which operating effc function *)
      effc = fun (type int) (eff: int t) -> 
      match eff with
      | Xchg n -> Some (fun (k: (int, _) continuation) -> continue k (n+1))
      | _ -> None 
    }
  in
  (* try_with execute computation1 -> handler handles the effect Xchg  *)
  let result = try_with computation1 () handler in
  Printf.printf "Result: %d\n" result

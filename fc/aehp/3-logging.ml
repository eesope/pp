open Effect
open Effect.Deep

type _ Effect.t += Log : string -> unit Effect.t

let log message = perform (Log message)

let handle_logs computation =
  let handler =
    { effc = fun (type a) (eff: a t) ->
        match eff with
        | Log msg -> Some (fun (k: (a, _) continuation) ->
            Printf.printf "LOG: %s\n" msg;
            continue k ()) 
        | _ -> None
    }
  in
  try_with computation () handler

let test_logging () =
  log "Starting computation"; 
  let result = 42 in           
  log "Computation finished";  (* continue to perform another Log effect *)
  Printf.printf "Result: %d\n" result

let () = handle_logs test_logging
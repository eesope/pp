open Effect
open Effect.Deep

type _ Effect.t += Async : unit -> 'a t

let async computation = perform (Async computation)

let run_async computation =
  match computation () with
  | effect (Async c) k ->
      let result = c () in
      continue k result
  | v -> v

let () =
  let computation () =
    let x = async (fun () -> 42) in
    let y = async (fun () -> x + 8) in
    Printf.printf "Result: %d\n" y
  in
  run_async computation

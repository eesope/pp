effect Retry : int

let retryable computation =
  try computation ()
  with
  | effect Retry k ->
      Printf.printf "Retrying...\n";
      continue k 1

let test_retry () =
  let x =
    let attempt = perform Retry in
    if attempt = 1 then raise (Failure "Failed on first attempt");
    attempt * 2
  in
  Printf.printf "Result: %d\n" x

let () = retryable test_retry

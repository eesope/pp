type ('a, 's) state = State of ('s -> 'a * 's)

let state f = State f

let run_state (State f) s = f s

let return x = State (fun s -> (x, s))

let ( >>= ) m f =
  State (fun s ->
      let (x, s') = run_state m s in
      run_state (f x) s')

let ( >> ) m1 m2 =
  m1 >>= fun _ -> m2

let ( let* ) = ( >>= )

let push x s = x :: s

let pop s =
  match s with
  | [] -> failwith "pop: empty stack"
  | _ :: xs -> xs

let top s =
  match s with
  | [] -> failwith "top: empty stack"
  | x :: _ -> x

let push' x = state (fun s -> ((), push x s))
let pop' = state (fun s -> ((), pop s))
let top' = state (fun s -> (top s, s))

let ex =
  pop' >>
  pop' >>
  top' >>= fun x ->
  pop' >>
  top' >>= fun y ->
  return (x + y)

let ex2 =
  pop' >>
  pop' >>
  let* x = top' in
  pop' >>
  let* y = top' in
  return (x + y)

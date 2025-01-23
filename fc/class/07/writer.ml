(* writer monad - used for logging *)
let return x = (x, "")

let ( >>= ) (x, s) f =
  let (x', s') = f x in
  (x', s ^ s')

let ( >> ) m1 m2 =
  m1 >>= fun _ -> m2

let inc x = (x + 1, "inc " ^ string_of_int x ^ "; ")
let dec x = (x - 1, "dec " ^ string_of_int x ^ "; ")

let tell s = ((), s)

(* regular gcd *)
let rec gcd a b =
  if b = 0 then a
  else gcd b (a mod b)

let rec logged_gcd a b =
  if b = 0 then tell (Printf.sprintf "gcd is %d" a) >> return a
  else tell (Printf.sprintf "gcd %d %d; " a b) >> logged_gcd b (a mod b)


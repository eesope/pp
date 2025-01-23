let return x = (x, [])

let ( >>= ) (x, l) f =
  let (x', l') = f x in
  (x', l @ l')

let inc x = (x + 1, ["inc " ^ string_of_int x])
let dec x = (x - 1, ["dec " ^ string_of_int x])

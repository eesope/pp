let rec sum acc =
  try
    sum (Scanf.scanf " %d" (fun x -> acc + x)) 
  with
  | _ -> acc

let () =
  Printf.printf "%d\n" @@ sum 0

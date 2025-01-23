let rec count acc =
  try
    ignore @@ read_line ();
    count (acc + 1)
  with
  | End_of_file -> acc

let () =
  print_int @@ count 0;
  print_newline ()

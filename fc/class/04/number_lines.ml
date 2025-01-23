let rec number_lines acc =
  try
    Printf.printf "%03d: %s\n" acc (read_line ());
    number_lines (acc + 1)
  with
  | End_of_file -> ()

let () = number_lines 1

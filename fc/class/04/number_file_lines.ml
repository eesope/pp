let rec number_lines ic acc =
  try
    Printf.printf "%03d: %s\n" acc (input_line ic);
    number_lines ic (acc + 1)
  with
  | End_of_file -> close_in ic; ()

let () = 
  if Array.length Sys.argv > 1 then
  let ic = open_in Sys.argv.(1) in
  number_lines ic 1

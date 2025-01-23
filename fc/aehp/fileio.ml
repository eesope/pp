effect FileNotFound : string

let read_file filename =
  if Sys.file_exists filename then
    Some (Stdlib.open_in filename |> input_line)
  else
    perform FileNotFound

let handle_file_read computation =
  try computation ()
  with
  | effect FileNotFound -> fun filename -> Printf.printf "File %s not found\n" filename; None

let () =
  handle_file_read (fun () -> read_file "test.txt")

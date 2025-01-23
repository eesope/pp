(* 
- Read txt file; print random line among the file
- Through terminal type:
  ocamlbuild file_name.native 
  ./file_name.native input.txt
*)

(* read file *)
let rec write_rq ic acc =
  try
    let line = input_line ic in
    write_rq ic (line :: acc)
  with 
  | End_of_file -> acc

(* print the random index# in range(0:list index) of string *)
let rand_q lst =
  let index = Random.int (List.length lst) in
  List.nth lst index

let () =
  Random.self_init();
  let ic = 
    if Array.length Sys.argv > 1 then
      open_in Sys.argv.(1)
    else stdin
  in
  let prac_lst = write_rq ic [] in
  let prac_q = rand_q prac_lst in
  print_endline prac_q;
  if Array.length Sys.argv > 1 then close_in ic
(* 
- Read each line from an input file or the standard IO
- Through terminal type:
  ocamlbuild sort.native 
  ./sort.native input.txt
*)

type record = {id: string; score: int}

(* [is_valid_id id] returns bool value after testing whether a string is a valid ID *)
let is_valid_id id = 
  id.[0] = 'A' && 
  String.length id = 9 &&
  try
    ignore @@ int_of_string (String.sub id 1 8); true
  with
  | Failure _ -> false


(* [is_valid_score score] reterns bool vlaue after testing whether an integer is a valid score *)
let is_valid_score score = 
  0 <= score && score <= 100


(* [parse sting] returns record type after getting a valid record from a string *)
let parse line =
  let plst = List.filter (fun x -> x <> "") (String.split_on_char ' ' line) in
  match plst with
  | id :: score_str :: _ ->
    (try
      let score = int_of_string score_str in
      if is_valid_id id && is_valid_score score then
        Some {id = id; score = score}
      else 
          None
    with
    | Failure _ -> None)
  | _ -> None


(* [sort_records records] returns sorted list of records in specified order *)
let sort_records records =
  records
  |>
  List.sort 
    (fun x1 x2 -> 
      if x1.score = x2.score then compare x1.id x2.id
      else compare x1.score x2.score)
  |> List.rev 


(* [sort ic line] Drive the sort program; reads and sorts records from the input channel or standard input *)
let rec sort ic acc = 
  try
    let line = input_line ic in
    let parsed = parse line in
    
    match parsed with
    | Some record -> 
      if is_valid_id record.id && is_valid_score record.score then
        sort ic (parsed :: acc)
      else 
        sort ic acc  
    | None -> sort ic acc
  with
  | End_of_file -> 
    let valid_records = List.filter_map (fun x -> x) acc in
    sort_records valid_records

let () =
  let ic = 
    if Array.length Sys.argv > 1 then
      open_in Sys.argv.(1)
    else 
      stdin
    in 
    let sorted_records = sort ic [] in
    List.iter (fun {id; score} -> Printf.printf "%3d %s \n" score id) sorted_records;
    if Array.length Sys.argv > 1 then close_in ic

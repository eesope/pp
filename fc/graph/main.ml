(* prerequisites: digraph.cmo is loaded on utop *)

open Digraph
module Graph = Digraph

let dijkstra (start : string) (goal : string) (graph : Graph.t) : int * string list =
  let module StringSet = Set.Make(String) in
  let module StringMap = Map.Make(String) in

  (* process the priority queue *)
  let rec aux visited priority_que length previous =
    match priority_que with
    | [] -> failwith "No suitable path"
    | (cost, current_vertex) :: rest ->
        if current_vertex = goal then
          
          (* look through all the previous map to find final result *)
          let rec find_shortest_path acc vertex =
            if vertex = start then vertex :: acc
            else find_shortest_path (vertex :: acc) (StringMap.find vertex previous)
          in
          (cost, find_shortest_path [] current_vertex)

        else if StringSet.mem current_vertex visited then
          (* skip already visited vertex *)
          aux visited rest length previous

        else  
          (* newly visit for new neighbors *)
          let neighbors = Graph.neighbors current_vertex graph in
          let updated_pq, updated_len, updated_prev = 

          List.fold_left 
          (fun (pq, len, prev) (neighbor, weight) -> 
            let new_cost = cost + weight in
            let old_cost = 
              match StringMap.find_opt neighbor len with
              | Some value -> value
              | None -> max_int
            in

            (* traverse new neighbor *)
            if new_cost < old_cost then

            (* update when shorter path found *)
              ((new_cost, neighbor) :: pq,
              StringMap.add neighbor new_cost len,
              StringMap.add neighbor current_vertex prev)

            else 
              (* no update *)
              (pq, len, prev))
            
            (rest, length, previous) neighbors
          
          in
          (* continue with updated state *)
          aux (StringSet.add current_vertex visited) (List.sort compare updated_pq) updated_len updated_prev

  (* init call *)
  in
  let length = StringMap.add start 0 StringMap.empty in
  let previous = StringMap.empty in
  
  aux StringSet.empty [(0, start)] length previous


let is_alphanum c =
  (Char.code c >= Char.code 'a' && Char.code c <= Char.code 'z') ||
  (Char.code c >= Char.code 'A' && Char.code c <= Char.code 'Z') ||
  (Char.code c >= Char.code '0' && Char.code c <= Char.code '9') 


let read_graph (filename : string) : Graph.t =
  let ic = open_in filename in
  let rec read_all acc = 
    try
      (* read line input *)
      let line = input_line ic in 
      read_all (line :: acc)
    with End_of_file ->
      close_in ic;
      List.rev acc
    in 
    (* process line to use as proper data *)
    let lines = List.filter (fun line -> String.trim line <> "") (read_all []) in
    let clean_line line = 
      String.map (fun c -> if is_alphanum c then c else ' ') line
      |> String.trim
      |> String.split_on_char ' '
      |> List.filter (fun s -> String.trim s <> "")
    in
    let edges = List.map
        (fun line -> 
          match clean_line line with
          | v1 :: v2 :: w :: _ ->
              ((String.uppercase_ascii v1), (String.uppercase_ascii v2), (int_of_string w))
          | _ -> failwith "Invalid line in file")
        lines
  in
  Graph.of_edges edges

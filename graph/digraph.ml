module StringMap = Map.Make(String)   (* Map module setup key as String *)

type t = (string * int) list StringMap.t
type edge = string * string * int

exception Inv_edge
exception Inv_graph

let empty : t = StringMap.empty

let validate_edge (v1, v2, l) = 
  if v1 = "" || v2 = "" || v1 = v2 || l <= 0 then raise Inv_edge

let add_edge (edge : edge) (graph: t) : t =
  let (v1, v2, l) = edge in
  validate_edge edge;
  match StringMap.find_opt v1 graph with
  | Some neighbors -> 
    if List.exists (fun (v0, l0) -> v0 = v2 && l0 <> l) neighbors 
      then raise Inv_graph else
        StringMap.add v1 ((v2, l) :: neighbors) graph
  | None -> StringMap.add v1 [(v2, l)] graph 

let of_edges (edges : edge list) : t =
  List.fold_left (fun graph edge -> add_edge edge graph) empty edges

let edges (graph : t) : edge list = 
  StringMap.fold (fun v1 neighbors acc -> 
    List.fold_left (fun acc (v2, l) -> (v1, v2, l) :: acc) acc neighbors) graph []
  |> List.sort_uniq compare

let vertices (graph : t) : string list = 
    StringMap.fold (fun v1 neighbors acc -> 
      let destination = List.map fst neighbors in
      v1 :: (destination @ acc)) graph []
    |> List.sort_uniq compare


(* 
  let compare_edge (v1, v2, l) (v1', v2', l') =
  let c1 = String.compare v1 v1' in
  if c1 <> 0 then c1
  else
    let c2 = String.compare v2 v2' in
    if c2 <> 0 then c2
    else Int.compare l l'

  let vertices (graph : t) : string list =
    List.fold_left
      (fun acc (src, neighbors) ->
        let acc = if List.mem src acc then acc else src :: acc in
        List.fold_left (fun acc (dest, _) -> if List.mem dest acc then acc else dest :: acc) acc neighbors)
      []
      graph
    |> List.sort_uniq String.compare
*)

let neighbors (vertex : string) (graph : t) : (string * int) list = 
  match StringMap.find_opt vertex graph with
  | Some neighbors -> neighbors
  | None -> []

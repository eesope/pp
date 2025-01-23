(* prerequisites: digraph.cmo is loaded on utop *)

module Graph = Digraph   (* alias for Digraph *)

(* [dijkstra start goal graph] calculates the shortest path from [start] to [goal] in the given [graph] *)
val dijkstra : string -> string -> Graph.t -> int * string list

(* [read_graph filename] reads a graph from a file [filename] *)
val read_graph : string -> Graph.t

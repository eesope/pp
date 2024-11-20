module Graph = Digraph
(* Graph module is an alias for Digraph. *)

val dijkstra : string -> string -> Graph.t -> int * string list
(* [dijkstra start goal graph] calculates the shortest path from [start] to [goal] in the given [graph].
   Returns a pair of the length of the shortest path and the list of vertices in the path. *)

val read_graph : string -> Graph.t
(* [read_graph filename] reads a graph from a file [filename]. 
   Returns a graph constructed from the edges described in the file. *)

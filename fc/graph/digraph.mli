type t                              (* the abstract digraph type *)
type edge = string * string * int   (* type of an edge *)

(** raised by [add_edge] and [of_edges] when an edge is invalid;
    An edge is valid iff its two vertices are labelled by distinct non-empty
    strings and its length is positive *)
exception Inv_edge

(** raised by [add_edge] and [of_edges] when adding a valid edge to a digraph 
    makes the digraph invalid.  This happens when adding the edge results in
    "duplicate" edges with different lengths. 
*)
exception Inv_graph

(** [empty] is the empty digraph *)
val empty : t

(** [add_edge edge graph] adds [edge] to [graph]. 
    Raises: [Inv_edge] if [edge] is invalid; raises [Inv_graph] if [edge] is
            a duplicate with a different length *)
val add_edge : edge -> t -> t

(** [of_edges edges] is the digraph formed from the list [edges].
    May raise [Inv_edge] or [Inv_graph] (see above) *)
val of_edges : edge list -> t 

(** [edges graph] is the sorted list of all distinct edges in [graph] *)
val edges : t -> edge list  

(** [vertices graph] is the list of all distinct vertices (in alphabetical
    order) of [graph] *)
val vertices : t -> string list 

(** [neighbors vertex graph] is the list of neighbors of [vertex] in
    [graph]; each neighbor is a pair of the form ([vertex2], [length]) which
    indicates there is an edge from [vertex] to [vetex2] of length [length]) *)
val neighbors : string -> t -> (string * int) list 

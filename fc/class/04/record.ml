type student = {id: string; name: string; gpa: float}

let s1 = {id = "a12345678"; name = "homer simpson"; gpa = 25.5}
let s2 = {s1 with gpa = 50.0}

let make_student id name gpa = {id; name; gpa}
let name {name; _} = name

type student' = {id: string; name: string; mutable gpa: float}
let s1' = {id = "a12345678"; name = "homer simpson"; gpa = 25.5}
(* s1'.gpa <- 49.9 (* OK, gpa is mutable *) *)

(* let s2' = s1'
 * s1'.gpa <- 50.  (* note: this also changes s2'.gpa *) *)


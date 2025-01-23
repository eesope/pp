let a = [| 1; 2; 3 |]
(*
   a.(0)
   a.(0) <- -1  (* arrays are mutable *)
*) 

let print_int_array a =
  for i = 0 to Array.length a - 1 do
    print_int a.(i); print_newline ()
  done

let rev_print_int_array a =
  for i = Array.length a - 1 downto 0 do
    print_int a.(i); print_newline ()
  done

(* also while
 * while ... do
 *   ...
 * done
 *)   

let isqrt n =
  n |>
  float_of_int |>
  sqrt |>
  int_of_float

let primes n =
  let isprime = Array.make n true in
  for i = 2 to isqrt n do
    if isprime.(i) then
      let j = ref i in
      while !j * i < n do
        isprime.(!j * i) <- false; incr j
      done
  done;
  isprime.(0) <- false;
  isprime.(1) <- false;
  isprime |> 
  Array.to_list |>
  List.mapi (fun i x -> (i, x)) |>
  List.filter_map (fun (i, x) -> if x then Some i else None)

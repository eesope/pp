(* 1a *)
(* rev_map f [1; 2; 3] -> [9; 4; 1]*)
let rev_map f lst =
  List.fold_left (fun acc x -> (f x) :: acc) [] lst

(*　失敗 *)
(* keyword of fun *)
(* fold_left to rev *)
(* how to pass the function *)


(* 1b *)
(* use List.fold_left once *)
(* sum_odd_even [1; 2; 3] -> (4, 2) *)
let sum_odd_even lst =
  List.fold_left (fun (odd, even) x -> if x mod 2 = 0 then (odd, x + even) else (x + odd, even)) (0, 0) lst
(* or *)
let sum_even_odd lst = 
  List.fold_left (fun (odd, even) x -> if x mod 2 <> 0 then (odd + x, even) else (odd, even + x)) (0, 0) lst
(* too far away; need much more steps forward *)
(* let odd_list = 
  List.fold_left (fun x -> x mod 2 == 1) [] lst in
let odd_sum =
  List.map (fun acc x -> x + acc) odd_list in *)


(* 2 *)
(* recursion *)
(* intersperse 0 [1; 2; 3] -> [1; 0; 2; 0; 3] *)
let rec intersperse x lst =
  match lst with
  | [] | [_] -> lst
  | y :: ys -> y :: x :: intersperse x ys


(* 3a *)
(* remove_all_tr 3 [1; 2; 3; 4] -> [1; 2; 4]*)
let remove_all_tr x lst = 
  let rec aux acc x lst =
    match lst with
    | [] -> List.rev acc
    | y :: ys -> if x <> y then aux (y :: acc) x ys else aux acc x ys
  in aux [] x lst


(* 3b *)
let remove_all_fold x lst = 
  List.rev(List.fold_left (fun acc y -> if x <> y then (y :: acc) else acc) [] lst)

(* 失敗 *)
(* 要　List.rev *)
(* annonymous function of List.fold_left -> only takes two parameters 
 eg. fun acc y *)
(* List.fold_left takes parameters in order of -> accumulated value, element of the list 
 eg. fun acc y *)

(** [drop_while f lst] returns lst with leading elements satisfying function f dropped. *)
let rec drop_while f lst = 
  match lst with 
  | [] -> []
  | x :: xs -> 
    if f x 
      then drop_while f xs 
    else lst

let test_drop_while () =
  assert (drop_while (fun x -> x < 3) [1; 2; 3; 4; 5] = [3; 4; 5]);
  assert (drop_while (fun x -> x mod 2 = 0) [2; 4; 6; 1; 3] = [1; 3]);
  assert (drop_while (fun _ -> true) [1; 2; 3] = [])


(** [zip_with f lst1 lst2] returns a list whose elements are obtained by 
applying function f to corresponding elements of 1st1 and Ist2. *)
let zip_with f lst1 lst2 = 
  let rec aux f lst1 lst2 acc = 
    match lst1, lst2 with
    | [], [] -> List.rev acc
    | _, [] | [], _ -> List.rev acc
    | x1 :: xs1, x2 :: xs2 -> 
        aux f xs1 xs2 ((f x1 x2) :: acc)
  in 
  aux f lst1 lst2 []

let test_zip_with () =
  assert (zip_with (+) [1; 2; 3] [4; 5; 6] = [5; 7; 9]);
  assert (zip_with ( * ) [1; 2; 3] [4; 5; 6] = [4; 10; 18]);
  assert (zip_with min [5; 3; 8] [7; 1; 9] = [5; 1; 8])


(** [mapi f l] returns a new list that consist of the index and the value of each element of a list. *)
let mapi f lst = 
  let rec aux i lst acc = 
    match lst with
    | [] -> List.rev acc
    | x :: xs -> aux (i + 1) xs ((f i x) :: acc)
  in
  aux 0 lst []

let test_mapi () =
  assert (mapi (fun i x -> i + x) [1; 2; 3] = [1; 3; 5]);
  assert (mapi (fun i x -> i * x) [1; 2; 3] = [0; 2; 6]);
  assert (mapi (fun i x -> i - x) [1; 2; 3] = [-1; -1; 0])
  
  
(** [every n lst] returns a list consisting of every n-th element of 1st. 
Requires: [n] is positive number *)
let rec every n lst = 
  lst 
  |> mapi (fun i x -> (i+1, x))
  |> List.filter (fun (i, _) -> i mod n = 0)
  |> List.map snd

let test_every () =
  assert (every 2 [1; 2; 3; 4; 5] = [2; 4]);
  assert (every 3 [1; 2; 3; 4; 5] = [3]);
  assert (every 1 [1; 2; 3; 4; 5] = [1; 2; 3; 4; 5])

  
(** [dedup lst] returns a list where all consecutive duplicated elements in lst 
are collapsed into a single element.  *)
let dedup lst =
  let aux acc x = 
    match acc with
    | [] -> [x]
    | xs :: _ when x = xs -> acc 
    | _ -> x :: acc
  in
  List.rev (List.fold_left aux [] lst)

let test_dedup () = 
  assert (dedup [1; 1; 2; 3; 3; 3; 2; 1; 1] = [1; 2; 3; 2; 1]);
  assert (dedup [5; 5; 2; 3; 3; 3; 2; 5; 5] = [5; 2; 3; 2; 5]);
  assert (dedup [1; 1; 2; 4; 4; 4; 2; 1; 1] = [1; 2; 4; 2; 1])

(** [group lst] returns a list with consecutive identical elements 
in a list in a sub-listed. *)
let group lst = 
  let aux acc x =
    match acc with
    | [] -> [[x]]
    | (y :: ys) :: rest when y = x -> (x :: y :: ys) :: rest
    | _ -> [x] :: acc
  in
  List.rev(List.fold_left aux [] lst)

let test_group () = 
  assert (group [12; 34; 34; 34; 5; 12; 12; 6; 78; 90; 90] = [[12]; [34; 34; 34]; [5]; [12; 12]; [6]; [78]; [90; 90]]);
  assert (group [1; 1; 2; 3; 3; 3] = [[1; 1]; [2]; [3; 3; 3]]);
  assert (group [1; 1; 3; 2; 3; 3] = [[1; 1]; [3]; [2]; [3; 3]]);
  assert (group [5; 5; 5] = [[5; 5; 5]])  


(** [frequencies lst] returns a list of pairs, 
element and counts of how many times each element occurs in the list. 
The order of the pairs can be in any order. *)
let frequencies lst =
  lst
  |> List.sort compare
  |> group
  |> List.fold_left (fun acc x ->
    match x with
    | [] -> acc
    | _ -> 
      let elt = List.hd x in
      let count = List.length x in
      (elt, count) :: acc
    ) []

let test_frequencies () = 
  assert (frequencies [23; 12; 15; 12; 45; 15; 13; 45; 15; 12; 15; 15] = [(23, 1); (12, 3); (15, 5); (13, 1); (45, 2)]);
  assert (frequencies [1; 1; 2; 3; 3; 3] = [(1, 2); (2, 1); (3, 3)]);
  assert (frequencies [5; 5; 5] = [(5, 3)])
(** [drop n l] returns l with the first n elements dropped. *)
let rec drop n l =
  if n <= 0 then l
  else
    match l with
    | [] -> []
    | _ :: xs -> drop (n - 1) xs

let test_drop () = 
  assert(drop 3 [4;2;6;7;6;8;1] = [7;6;8;1]);
  assert(drop (-1) [3; 2; 7] = [3;2;7]);
  assert(drop 4 [3;2;7] = [])


(** [zip lst1 lst2] returns a list consisting of pairs 
    of corresponding elements of 1st1 and 1st2. 
    If 1st1 and 1st2 are of different lengths, 
    the function stops "zipping" when hte shorter list ends. *)
let rec zip lst1 lst2 =
  match lst1, lst2 with
  | [], [] -> []
  | _, [] | [], _ -> []
  | x1 :: xs, x2 :: xs2 -> (x1, x2) :: zip xs xs2

(** Tail-recursive version of zip *)
let zip_tr lst1 lst2 = 
  let rec aux lst1 lst2 acc = 
    match lst1, lst2 with
    | [], [] -> acc
    | _, [] | [], _ -> []
    | x1 :: xs, x2 :: xs2 -> aux xs xs2 ((x1, x2) :: acc)
  in
  aux lst1 lst2 []

let test_zip () =
  assert (zip [1; 2; 3] ['a'; 'b'; 'c'; 'd'] = [(1, 'a'); (2, 'b'); (3, 'c')]);
  assert (zip [1; 2] ['a'; 'b'; 'c'] = [(1, 'a'); (2, 'b')]);
  assert (zip [] [] = [])

let test_zip_tr () =
  assert (zip_tr [1; 2; 3] ['a'; 'b'; 'c'; 'd'] = [(1, 'a'); (2, 'b'); (3, 'c')]);
  assert (zip_tr [1; 2] ['a'; 'b'; 'c'] = [(1, 'a'); (2, 'b')]);
  assert (zip_tr [] [] = [])


(** [unzip lst] returns a pair of lists where the first list consists of 
    the first element of each pair in lst and the second list consists of 
    the second element of each pair in lst. *)
let rec unzip lst =
  match lst with
  | [] -> ([], [])
  | (x1, x2) :: xs -> 
    let (lst1, lst2) = unzip xs in
    (x1 :: lst1, x2 :: lst2)

(** Tail-recursive version of unzip *)
let unzip_tr lst = 
  let rec aux lst acc1 acc2 =
    match lst with
    | [] -> (List.rev acc1, List.rev acc2)
    | (x1, x2) :: xs -> aux xs (x1 :: acc1) (x2 :: acc2) 
  in
  aux lst [] []

let test_unzip () =
  assert (unzip [(1, 'a'); (2, 'b')] = ([1; 2], ['a'; 'b']));
  assert (unzip [] = ([], []));
  assert (unzip [(1, 'a'); (2, 'b'); (3, 'c')] = ([1; 2; 3], ['a'; 'b'; 'c']))

let test_unzip_tr () =
  assert (unzip_tr [(1, 'a'); (2, 'b')] = ([1; 2], ['a'; 'b']));
  assert (unzip_tr [] = ([], []));
  assert (unzip [(1, 'a'); (2, 'b'); (3, 'c')] = ([1; 2; 3], ['a'; 'b'; 'c']))


(** [dedup lst] returns a list where all consecutive duplicated elements in lst 
    are collapsed into a single element. *)
let rec dedup lst = 
  match lst with
  | [] -> []
  | [x] -> [x]
  | x1 :: (x2 :: _ as xs) -> 
    if x1 = x2 then 
      dedup xs 
    else 
      x1 :: dedup (x2 :: xs)

(** Tail-recursive version of dedup *)
let dedup_tr lst = 
  let rec aux lst acc = 
    match lst with 
    | [] -> List.rev acc
    | [x] -> List.rev (x :: acc)
    | x1 :: (x2 :: _ as xs) -> 
      if x1 = x2 then
        aux xs acc
      else 
        aux (x2 :: xs) (x1 :: acc)
  in
  aux lst []

let test_dedup () = 
  assert (dedup [1; 1; 2; 3; 3; 3; 2; 1; 1] = [1; 2; 3; 2; 1]);
  assert (dedup [5; 5; 2; 3; 3; 3; 2; 5; 5] = [5; 2; 3; 2; 5]);
  assert (dedup [1; 1; 2; 4; 4; 4; 2; 1; 1] = [1; 2; 4; 2; 1])

let test_dedup_tr () = 
  assert (dedup_tr [1; 1; 2; 3; 3; 3; 2; 1; 1] = [1; 2; 3; 2; 1]);
  assert (dedup_tr [5; 5; 2; 3; 3; 3; 2; 5; 5] = [5; 2; 3; 2; 5]);
  assert (dedup_tr [1; 1; 2; 4; 4; 4; 2; 1; 1] = [1; 2; 4; 2; 1])

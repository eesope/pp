(* [digits i] returns the list of digits in a non-negative integer. *)
let digits i =
  let abs_i = abs i in
  let rec aux acc abs_i = 
    if (abs_i) < 10 then abs_i :: acc
    else aux ((abs_i mod 10) :: acc) (abs_i / 10) 
  in aux [] abs_i;;

(* [int_of_digits lst] returns an integer from a list of its digits *)
  let int_of_digits lst =
  List.fold_left (fun acc num -> acc * 10 + num) 0 lst

(* [list_of_string str] returns the list of characters in a string, 
in the same order they occur in the string *)
let list_of_string str =
  String.fold_right (fun c acc -> c :: acc ) str []

  (* tail-recursive version *)
let list_of_string_tr str =
  let aux acc c = c :: acc in
    List.rev ( String.fold_left aux [] str)


(* [is_permutation str1 str2] returns boolean value 
whether two strings are permutation of each other *)
let is_permutation str1 str2 =
  if (String.length str1 <> String.length str2) then false
  else 
    let lst1 = List.sort compare (list_of_string str1) in
    let lst2 = List.sort compare (list_of_string str2) in
    lst1 = lst2

let test_digits () =
  assert (digits 3276 = [3; 2; 7; 6]);
  assert (digits 3958 = [3; 9; 5; 8]);
  assert (digits (-107) = [1; 0; 7])

let test_int_of_digits () =
  assert (int_of_digits [0; 3; 2; 7; 6] = 3276);
  assert (int_of_digits [3; 9; 5; 8] = 3958);
  assert (int_of_digits [0; 0; 7] = 7)
  
let test_list_of_string () =
  assert (list_of_string "hello" = ['h'; 'e'; 'l'; 'l'; 'o']);
  assert (list_of_string "comp" = ['c'; 'o'; 'm'; 'p']);
  assert (list_of_string "domingo" = ['d'; 'o'; 'm'; 'i'; 'n'; 'g'; 'o'])
  
let test_is_permutation () =
  assert (is_permutation "hello" "leolh" = true);
  assert (is_permutation "hello" "hell" = false);
  assert (is_permutation "comp" "math" = false)

let () =
test_digits();
test_int_of_digits();
test_list_of_string();
test_is_permutation()

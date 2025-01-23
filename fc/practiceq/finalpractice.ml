(* Basics, pattern matching *)

(**
1. Write a function [shuffle lst] that for some list of length n, the
  output is a list of the same length, with the last n/2 elements inserted
  between the first n/2 elements.
  ie. [a;b;c;d;e;f] -> [a;f;b;e;c;d]
*)
let shuffle lst =
  let rec f l acc =
    match l with
    | [] -> List.rev acc
    | x::xs -> (f (List.rev xs) (x::acc))
  in f lst []


(**
2. Write a function [pascal i] that returns the i'th row (1-indexed)
  of Pascal's triangle.
*)
let rec pascal i =
  match i with
  | n when n <= 0 -> []
  | n when n = 1 || n = 2 -> List.init n (fun _ -> 1)
  | n -> let prev_row = pascal (n - 1) in
    let rec f l =
      match l with
      | [] -> []
      | n::[] -> [n]
      | a::b::xs when a = 1 -> 1 :: (a+b) :: f (b::xs)
      | a::b::xs -> (a+b) :: f (b::xs)
    in f prev_row

(**
3. Write a function [addb lst1 lst2], adding two lists representing a binary string (list items
  are 0 or 1 only). The binary strings are right-justified.
  ie. for two strings [1; 0; 0; 0; 1] and [1; 1; 1], they are aligned as:
    [1; 0; 0; 0; 1]
          [1; 1; 1]
*)
let addb lst1 lst2 =
  let bin1 = List.rev lst1 in
  let bin2 = List.rev lst2 in
  let rec ab l1 l2 carry acc =
    match l1, l2 with
    | [], [] -> acc
    | b1::b1s, [] -> ab b1s [] ((b1 + carry) / 2) (((b1 + carry) mod 2)::acc)
    | [], b2::b2s -> ab [] b2s ((b2 + carry) / 2) (((b2 + carry) mod 2)::acc)
    | b1::b1s, b2::b2s -> ab b1s b2s ((b1 + b2 + carry) / 2) (((b1 + b2 + carry) mod 2)::acc)
  in ab bin1 bin2 0 []


(**
4. Write a function [gcf i1 i2] that returns the greatest common factor between two
  positive integers i1 and i2 (the largest number that divides evenly into both numbers).
*)
let gcf i1 i2 =
  if i1 = i2 then i1
  else if i1 <= 0 || i2 <= 0 then 0
  else
    let rec f int1 int2 =
      match int1, int2 with
      | 1, _ | _, 1 -> 1
      | a, b ->
        if a < b && i1 mod a = 0 && i2 mod a = 0 then a
        else if a > b && i1 mod b = 0 && i2 mod b = 0 then b
        else if a < b then f (a - 1) b
        else f a (b - 1)
    in f i1 i2

(* Trees (Records and variants) *)
type 'a t_r = Leaf | Node of {v: 'a; l: 'a t_r; r: 'a t_r}
(* type 'a t = Leaf | Node of 'a * 'a t * 'a t *)

(* Helper insert function *)
let rec insert i t =
  match t with
  | Leaf -> Node {v=i; l=Leaf; r=Leaf}
  | Node n ->
    if i < n.v then Node {n with l = insert i n.l}
    else if i > n.v then Node {n with r = insert i n.r}
    else Node n

(* Helper empty function *)
let empty = Leaf

(**
5. Write a function [flip tree] that flips the tree across the middle (vertical axis)
  so that the resulting tree is a mirror of the original.
*)
let rec flip tree =
  match tree with
  | Leaf -> Leaf
  | Node n -> Node {n with l = flip n.r; r = flip n.l} 


(**
6a. Implement the mem function [mem value tree] that checks whether that value is
    a member of (exists in) the tree.
*)
let rec mem value tree =
  match tree with
  | Leaf -> false
  | Node n ->
    if value = n.v then true
    else (mem value n.l) || (mem value n.r)

(**
6b. With help of the mem function from above, implement [swap v1 v2 tree] that swaps
    the positions of the two values v1 and v2 in the tree if they exist, otherwise
    just returns the original tree.
*)
let swap v1 v2 tree =
  if (mem v1 tree) && (mem v2 tree) then
    let rec swp a b tr =
      match tr with
      | Leaf -> Leaf
      | Node n ->
        if n.v = a then (Node {v = b; l = swp a b n.l; r = swp a b n.r})
        else if n.v = b then (Node {v = a; l = swp a b n.l; r = swp a b n.r})
        else (Node {n with l = swp a b n.l; r = swp a b n.r})
    in swp v1 v2 tree
  else tree

(**
7. Write a function [sum_of_row i tree] that returns the sum of all numbers in the i'th
  row of the tree (1-indexed. The top root is the first row)
*)
let rec sum_of_row i tree =
  if i <= 0 then 0
  else if i = 1 then
    match tree with
    | Leaf -> 0
    | Node n -> n.v
  else
    match tree with
    | Leaf -> 0
    | Node n -> (sum_of_row (i - 1) n.l) + (sum_of_row (i - 1) n.r)

let rec sum_of_row2 i tree =
  match tree with
  | Leaf -> 0
  | Node n when i = 1 -> n.v
  | Node n when i > 1 -> (sum_of_row2 (i - 1) n.l) + (sum_of_row2 (i - 1) n.r)
  | Node _ -> 0


(* Streams *)

type 'a infstream = Cons of 'a * (unit -> 'a infstream)
let rec from n = Cons (n, fun () -> from (n + 1))
let nats = from 1
let hd (Cons(h,_)) = h
let tl (Cons(_,t)) = t
let rec take n s = if n <= 0 then [] else (hd s) :: (take (n - 1) (tl s ()))
let rec map f s = Cons (f (hd s), fun () -> map f (tl s ()))
let rec map2 f s1 s2 = Cons(f (hd s1) (hd s2), fun () -> map2 f (tl s1 ()) (tl s2 ()))

(**
8a. Using an infstream, write a recursive function [from_fact n] that behaves similar to
    the [from n] function from class, but instead returns a stream where the head is the
    factorial of the given number. You may use any of the functions given from class notes.
*)
let rec from_fact n = Cons(float_of_int (List.fold_left ( * ) 1 (take n nats)), fun () -> from_fact (n + 1))
let fact = from_fact 1

(**
8b. Given the formula for estimating the natural logarith base e (Euler's number)
    = sum from 0 to inf of (1 / n!), create a stream that returns the values of each
    n. Estimate the number using the first 10 values.
*)
let euler =
  let rec stream_1 = Cons(1., fun () -> stream_1) in
  map2 ( /. ) stream_1 (from_fact 0)


type 'a lazystream = Cons of 'a * ('a lazystream Lazy.t)
let rec from_l n = Cons(n, lazy (from_l (n + 1)))
let rec nats_l = from_l 1
let hd_l (Cons (h, _)) = h
let tl_l (Cons (_, t)) = t
let rec take_l n (Cons (h, t)) = if n <= 0 then [] else h :: (take_l (n - 1) (Lazy.force t))
let rec map_l f (Cons (h, t)) = Cons(f h, lazy (map_l f (Lazy.force t)))
let rec map2_l f (Cons (h1, t1)) (Cons (h2, t2)) =
  Cons (f h1 h2, lazy (map2_l f (Lazy.force t1) (Lazy.force t2)))
let rec unfold_l f x =
  let (v, x') = f x in Cons(v, lazy (unfold_l f x'))

(**
9. Estimate the number pi with the infinite series:
  3 + (4 / (2*3*4)) - (4 / (4*5*6)) + (4 / (6*7*8)) - (4 / (8*9*10)) ...
  using the unfold function and any other functions from class by creating
  the lazystream [est_pi], and estimate pi with the first 20 values
  from the stream.
*)
let est_pi =
  let number = unfold_l (fun (a) -> (a, (-a))) 4 in
  let denom = unfold_l (fun (a) -> (a *. (a +. 1.) *. (a +. 2.)), (a +. 2.)) 2. in
  map2_l ( /.) (map_l float_of_int number) denom


type num =
  | Int of int
  | Float of float

let add_num: num -> num -> num = fun num1 num2 ->
  match num1, num2 with
  | Int a, Float b -> Float ((float_of_int a) +. b)
  | Float a, Int b -> Float ((float_of_int b) +. a)
  | Float a, Float b -> Float (a +. b)
  | Int a, Int b -> Int (a + b)

let div_num num1 num2 =
  match num1, num2 with
  | _, Int 0 | _, Float 0. -> failwith "Divide by zero"
  | Int a, Int b -> Float ((float_of_int a) /. (float_of_int b))
  | Int a, Float b -> Float ((float_of_int a) /. b)
  | Float a, Int b -> Float (a /. (float_of_int b))
  | Float a, Float b -> Float (a /. b)

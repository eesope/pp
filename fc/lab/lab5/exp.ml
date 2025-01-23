type 'a lazystream = Cons of 'a * 'a lazystream Lazy.t

let rec from n = Cons (n, lazy(from (n + 1)))
let nats = from 0
let hd (Cons (h, _)) = h
let tl (Cons (_, t)) = Lazy.force t

let rec take n (Cons (h, t)) = 
  if n <= 0 then []
  else h :: take (n - 1) (Lazy.force t)

let rec fact n acc =
  Cons (acc, lazy (fact (n + 1) (acc *. float_of_int (n + 1))))

let rec pow x n =
  Cons (x ** float_of_int n, lazy (pow x (n + 1)))

let rec map2 f (Cons (h1, t1)) (Cons (h2, t2))= 
  Cons (f h1 h2, lazy (map2 f (Lazy.force t1) (Lazy.force t2)))

(* 2. (a) *)
(* [exp_terms] returns a lazy stream consisting of the terms as (x^index / index!) of the infinite series. *)

(* exp_terms v1; by using aux and index *)
let rec exp_terms x = 
  let rec aux i term =
    Cons (term, lazy (aux (i +. 1.0) (term *. x /. i))) 
  in aux 1.0 1.0

(* exp_terms version 2; by using map *)
let rec exp_terms2 x =
  let numerator = pow x 0 in
  let denumerator = fact 0 1.0 in
  map2 (fun n d -> n /. d) numerator denumerator

(* 2. (b) *)
(* sum of 20 terms for exp(1.1) shows 3.00416602394643384 for both above two versions of exo_terms *)
let sum_exp lst = 
  List.fold_left (fun acc x -> acc +. x) 0.0 lst

let apprx_val = sum_exp (take 20 (exp_terms 1.1))
let apprx_val2 = sum_exp (take 20 (exp_terms2 1.1))
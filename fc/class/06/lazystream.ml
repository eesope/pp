type 'a lazystream = Cons of 'a * 'a lazystream Lazy.t

let rec from n = Cons (n, lazy (from (n + 1)))

let nats = from 1

let hd (Cons (h, _)) = h

let tl (Cons (_, t)) = Lazy.force t

(* 무한 스트림 s -> (Cons (h, t)) 에서 처음 n개의 요소를 리스트로 반환 *)
let rec take n (Cons (h, t)) =
  if n <= 0 then []
  else h :: take (n - 1) (Lazy.force t)

(* 스트림 s에서 처음 n개의 요소를 건너뛰고 남은 스트림을 반환 *)
let rec drop n (Cons (h, t) as s) =
  if n <= 0 then s
  else drop (n - 1) @@ Lazy.force t

let rec map f (Cons (h, t)) =
  Cons (f h, lazy (map f (Lazy.force t)))

(* 두 스트림 s1과 s2의 각 요소를 함수 f에 적용하여 새로운 스트림을 생성 *)
let rec map2 f (Cons (h1, t1)) (Cons (h2, t2)) =
  Cons (f h1 h2, lazy (map2 f (Lazy.force t1) (Lazy.force t2)))

(* 두 스트림의 각 요소를 더한 스트림을 생성 *)
let sum = map2 (+)

let rec fibs =
  Cons (0, lazy (Cons (1, lazy (sum fibs (tl fibs)))))

let rec unfold f x =
  let (v, x') = f x in
  Cons (v, lazy (unfold f x'))

(* https://ocaml.org/docs/sequences *)
(* https://ocaml.org/p/sequence/1.0/doc/SequenceLabels/index.html *)
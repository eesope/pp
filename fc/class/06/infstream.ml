type 'a infstream = Cons of 'a * (unit -> 'a infstream)

let rec from n = Cons (n, fun () -> from (n + 1))

let nats = from 1

let hd (Cons (h, _)) = h

let tl (Cons (_, t)) = t ()

(* 무한 스트림 s -> (Cons (h, t)) 에서 처음 n개의 요소를 리스트로 반환 *)
let rec take n (Cons (h, t)) =
  if n <= 0 then []
  else h :: take (n - 1) (t ())

(* alternative version
let rec take n s =
  if n <= 0 then []
  else hd s :: take (n - 1) (tl s)
*) 

(* 스트림 s에서 처음 n개의 요소를 건너뛰고 남은 스트림을 반환 *)
let rec drop n ((Cons (h, t)) as s) =
  if n <= 0 then s
  else drop (n - 1) (t ())

let rec map f (Cons (h, t)) =
  Cons (f h, fun () -> map f (t ()))

let rec map2 f (Cons (h1, t1)) (Cons (h2, t2)) =
  Cons (f h1 h2, fun () -> map2 f (t1 ()) (t2 ()))

let sum = map2 (+)

let rec fibs = Cons (0, fun () -> Cons (1, fun () -> sum fibs (tl fibs)))

let rec unfold f x =
  let (v, x') = f x in
  Cons (v, fun () -> unfold f x')

(* state monad *)
type ('a, 's) state = State of ('s -> 'a * 's)

let state f = State f

let run_state (State f) s = f s

let return x = State (fun s -> (x, s))

let ( >>= ) m f =
  State (fun s ->
      let (x, s') = run_state m s in
      run_state (f x) s')

let ( >> ) m1 m2 =
  m1 >>= fun _ -> m2

let ( let* ) = ( >>= )

let get = State (fun s -> (s, s))
let put s = State (fun _ -> ((), s))

(* https://wiki.haskell.org/State_Monad#Complete_and_Concrete_Example_1
   - Passes a string from dictionary {a,b,c}
   - Game is to produce a number from the string.
   - By default the game is off, a 'c' toggles the game on and off. 
     An 'a' gives +1 and a 'b' gives -1.
  - E.g "ab"    = 0
        "ca"    = 1
        "cabca" = 0
  - State = game is on or off & current score = (Bool, Int)
*)
type game_value = int
type game_state = int * bool  (* score, on/off *)

let rec play_game' (l: char list) =
  match l with
  | [] ->
      let* (score, _) = get in
      return score
  | x::xs ->
      (
        let* (score, on) = get in
        match x with
        | 'a' when on -> put (score + 1, on)
        | 'b' when on -> put (score - 1, on)
        | 'c' -> put (score, not on)
        | _ -> put (score, on)
      )
      >> play_game' xs

let play_game str =
  play_game' @@ String.fold_right (fun x a -> x :: a) str []

let play str = run_state (play_game str) (0, false)

(* e.g. play "cabca" *)

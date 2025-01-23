(* Map module 을 사용하여 각 단어의 빈도를 카운트 *)

(* Map 은 dictionary 와 같은 자료 구조 -> key-value 를 저장하고, 검색하는데 사용 *)

module M = Map.Make(String)  (* String 을 key 로 사용하는 Map 을 정의 *)

let inc word map =
  M.update word (function | None -> Some 1 | Some n -> Some (n + 1)) map

  (* 
  function을 사용하면 람다로써 매개변수의 패턴을 직접 나열 가능 
  function
  | None -> Some 1 
  과 같은 것; fun x -> 의 경우 매개변수를 항상 받는다
  *)

let count () =  (* () -> 함수에 필요한 매개 변수 입력 필요 없음 *)
  let rec aux map =
    try
      (* Scanf.scanf 로 인해 count() 를 실행하면 사용자에게 문자열 input 을 받게 됨 *)
      aux (Scanf.scanf " %s" (fun x ->
          if x = "" then raise End_of_file
          else inc x map))
    with
    | _ -> map
  in M.bindings @@ aux M.empty  (* 단어 빈도를 계산한 맵을 리스트로 변환 *)

  (* bindings : 'a t -> (key * 'a) list*)
  (* @@ 함수 호출 연산자 : 연산자 오른쪽에 있는 표현식을 먼저 계산하여 그 결과를 왼쪽 함수에 전달
  f @@ x == (f x) *)

(* https://ocaml.org/docs/maps *)
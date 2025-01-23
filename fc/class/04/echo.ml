let () =
  let n = Array.length Sys.argv - 1 in
  for i = 1 to n do
    Printf.printf (if i = n then "%s\n" else "%s ") Sys.argv.(i)
  done

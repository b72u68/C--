if Array.length Sys.argv < 2 then
  (Printf.printf "Usage: ./tac [filename]\n";
   exit 1)
;;

let fname = Array.get Sys.argv 1

let basename =
  try Filename.chop_extension fname
  with Invalid_argument _ -> fname
          
let chan = open_in fname
let lexbuf = Lexing.from_channel chan

let p = Parser.prog Lexer.token lexbuf
let c = Compile.compile_stmt p
let c = Optimize.optimize c
let outch = open_out (basename ^ ".tac") 
let _ = Printtac.print_code outch c
let _ = close_out outch
(* let v = Interptac.interp c
let _ = Printf.printf "%d\n" v
 *)

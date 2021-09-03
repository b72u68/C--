if Array.length Sys.argv < 2 then
  (Printf.printf "Usage: ./tac <filename> [<var>=<val>]\n";
   exit 1)
;;

let fname = Array.get Sys.argv 1

let add env s =
  match String.split_on_char '=' s with
  | [x; v] -> Env.env_add env x (int_of_string v)
  | _ -> (Printf.printf "Usage: ./tac <filename> [<var>=<val>]\n";
          exit 1)

let env =
  Array.fold_left add Env.empty_env
    (Array.sub Sys.argv 2 ((Array.length Sys.argv) - 2))

let chan = open_in fname
let lexbuf = Lexing.from_channel chan

let p = Tacparser.code Taclexer.token lexbuf
let (v, l) = Interptac.interpwlen p env
let _ = Printf.printf "Instructions evaluated: %d\nResult: %d\n" l v

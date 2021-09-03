open Tac

let string_of_addr a =
  match a with
  | ANum n -> string_of_int n
  | AVar v -> v

let string_of_binop =
  function Plus -> "+" | Minus -> "-" | Div -> "/" | Times -> "*"

let string_of_instr i =
  match i with
  | Label l -> Printf.sprintf "%s:" l
  | Binop (d, o, s1, s2) ->
     Printf.sprintf "  %s = %s %s %s"
       d
       (string_of_addr s1)
       (string_of_binop o)
       (string_of_addr s2)
  | Copy (d, s) -> Printf.sprintf "  %s = %s" d (string_of_addr s)
  | Jump l -> Printf.sprintf "  jump %s" l
  | JumpIfZero (l, a) -> Printf.sprintf "  jz %s %s"
                           l
                           (string_of_addr a)
  | JumpIfNeg (l, a) -> Printf.sprintf "  jneg %s %s"
                          l
                          (string_of_addr a)
  | Ret a -> Printf.sprintf "  ret %s"
               (string_of_addr a)

let print_code f c =
  List.fold_left
    (fun () i -> Printf.fprintf f "%s\n" (string_of_instr i))
    ()
    c

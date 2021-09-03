type nbinop = Plus
            | Minus
            | Div
            | Times

type relop = Lt
           | Le
           | Gt
           | Ge
           | Eq
           | Ne

type var = string

type intexpr = Num of int
             | Var of var
             | NBinop of nbinop * intexpr * intexpr

type boolexpr = Relop of relop * intexpr * intexpr
              | And of boolexpr * boolexpr
              | Or of boolexpr * boolexpr
              | Not of boolexpr

type stmt = Assign of var * intexpr
          | If of boolexpr * stmt * stmt option
          | While of boolexpr * stmt
          | Return of intexpr
          | Block of stmt list

type label = string

type addr = ANum of int
          | AVar of var

type instr = Label of label
           | Binop of var * nbinop * addr * addr (* return, op1, op2 *)
           | Copy of var * addr
           | Jump of label
           | JumpIfZero of label * addr
           | JumpIfNeg of label * addr
           | Ret of addr

type code = instr list

let var_ctr = ref (-1)
let new_var () =
  let _ = var_ctr := (!var_ctr) + 1 in
  ("t" ^ (string_of_int (!var_ctr)))
let new_addr () = AVar (new_var ())

let lbl_ctr = ref (-1)
let new_label () =
  let _ = lbl_ctr := (!lbl_ctr) + 1 in
  ("l" ^ (string_of_int (!lbl_ctr)))

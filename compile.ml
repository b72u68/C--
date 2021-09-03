open Tac
exception ImplementMe

(*>* Problem 1.1 *>*)
let rec compile_intexpr (e: intexpr) : code * addr =
    match e with
    | Num n -> ([], ANum n)
    | Var x -> ([], AVar x)
    | NBinop (nb, e1, e2) ->
            let (c1, v1) = compile_intexpr e1 in
            let (c2, v2) = compile_intexpr e2 in
            let x = new_var () in
            (c1 @ c2 @ [Binop (x, nb, v1, v2)], AVar x)

(*>* Problem 1.2 *>*)
let rec compile_boolexpr (e: boolexpr) (t: label) (f: label) : code =
  match e with
  | Relop (Lt, e1, e2) ->
            let (c, a) = compile_intexpr (NBinop (Minus, e1, e2)) in
            c @ [JumpIfNeg (t, a); Jump f]
  | Relop (Gt, e1, e2) ->
            let (c, a) = compile_intexpr (NBinop (Minus, e2, e1)) in
            c @ [JumpIfNeg (t, a); Jump f]
  | Relop (Eq, e1, e2) ->
            let (c, a) = compile_intexpr (NBinop (Minus, e1, e2)) in
            c @ [JumpIfZero (t, a); Jump f]
  | Relop (Le, e1, e2) -> compile_boolexpr (Relop (Gt, e1, e2)) f t
  | Relop (Ge, e1, e2) -> compile_boolexpr (Relop (Lt, e1, e2)) f t
  | Relop (Ne, e1, e2) -> compile_boolexpr (Relop (Eq, e1, e2)) f t
  | And (e1, e2) ->
          let l = new_label() in
          let c1 = compile_boolexpr e1 l f in
          let c2 = compile_boolexpr e2 t f in
          c1 @ [Label l] @ c2
  | Or (e1, e2) ->
          let l = new_label() in
          let c1 = compile_boolexpr e1 t l in
          let c2 = compile_boolexpr e2 t f in
          c1 @ [Label l] @ c2
  | Not e1 -> compile_boolexpr e1 f t

(*>* Problem 1.3 *>*)
let rec compile_stmt (s: stmt) : code =
  match s with
  | Assign (x, e) ->
          let (c, a) = compile_intexpr e in
          let rec combine_var x a c =
              match a with
              | ANum _ -> c @ [Copy (x, a)]
              | AVar v ->
                      (match c with
                      | [] -> [Copy (x, a)]
                      | Binop (v', nb, v1, v2)::t ->
                              if v' = v then (Binop (x, nb, v1, v2))::t
                              else Binop(v', nb, v1, v2)::(combine_var x a t)
                      | Copy (v', a')::t ->
                              if v' = v then (Copy (x, a'))::(combine_var x a t)
                              else Copy (v', a')::(combine_var x a t)
                      | h::t -> h::(combine_var x a t))
          in
          combine_var x a c
  | If (e, ifb, None) ->
          let lif = new_label() in
          let lend = new_label() in
          let c = compile_boolexpr e lif lend in
          let cif = compile_stmt ifb in
          c @ [Label lif] @ cif @ [Label lend]
  | If (e, ifb, Some elseb) ->
          let lif = new_label() in
          let lelse = new_label() in
          let lend = new_label() in
          let c = compile_boolexpr e lif lelse in
          let cif = compile_stmt ifb in
          let celse = compile_stmt elseb in
          c @ [Label lif] @ cif @ [Jump lend; Label lelse] @ celse @ [Label lend]
  | While (e, s) ->
          let lcheck = new_label() in
          let lbody = new_label() in
          let lend = new_label() in
          let c = compile_boolexpr e lbody lend in
          let cbody = compile_stmt s in
          [Label lcheck] @ c @ [Label lbody] @ cbody @ [Jump lcheck; Label lend]
  | Return e ->
          let (c, a) = compile_intexpr e in
          c @ [Ret a]
  | Block b -> List.concat (List.map compile_stmt b)

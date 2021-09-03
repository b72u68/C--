open Tac
open Env
open Util

(* Apply an optimization "opt" repeatedly until it stops making the code
 * shorter. You can use this in your optimization if you want. *)
let rec fix (opt: code -> code) (c: code) =
  let c' = opt c in
  if List.length c' = List.length c then
    c'
  else
    fix opt c'

(*>* Problem 2.3 *>*)

let rec count_assign (v: var) (c: code) =
    match c with
    | [] -> 0
    | (Copy (v', _))::t ->
            if v' = v then 1 + count_assign v t
            else count_assign v t
    | (Binop (v', _, _, _))::t ->
            if v' = v then 1 + count_assign v t
            else count_assign v t
    | _::t -> count_assign v t

let rec propagating (x: var) (n: int) (c: code) =
    match c with
    | [] -> []
    | h::t ->
            (match h with
            | Binop (v, nb, AVar v1, AVar v2) ->
                    if v1 = x then
                        if v2 = x then (Binop (v, nb, ANum n, ANum n))::(propagating x n t)
                        else (Binop (v, nb, ANum n, AVar v2))::(propagating x n t)
                    else
                        if v2 = x then (Binop (v, nb, AVar v1, ANum n))::(propagating x n t)
                        else h::(propagating x n t)
            | Binop (v, nb, AVar v', ANum n') ->
                    if v' = x then (Binop (v, nb, ANum n, ANum n'))::(propagating x n t)
                    else h::(propagating x n t)
            | Binop (v, nb, ANum n', AVar v') ->
                    if v' = x then (Binop (v, nb, ANum n', ANum n))::(propagating x n t)
                    else h::(propagating x n t)
            | Copy (v, AVar v') ->
                    if v' = x then (Copy (v, ANum n))::(propagating x n t)
                    else h::(propagating x n t)
            | Ret (AVar v) ->
                    if v = x then Ret (ANum n)::(propagating x n t)
                    else h::(propagating x n t)
            | JumpIfZero (l, AVar v) ->
                    if v = x then (JumpIfZero (l, ANum n))::(propagating x n t)
                    else h::(propagating x n t)
            | JumpIfNeg (l, AVar v) ->
                    if v = x then (JumpIfNeg (l, ANum n))::(propagating x n t)
                    else h::(propagating x n t)
            | _ -> h::(propagating x n t))

let rec evaluate_vars (c: code) =
    match c with
        | Binop (v, nb, ANum n1, ANum n2)::t ->
                (match nb with
                | Plus -> Copy (v, ANum (n1 + n2))::(evaluate_vars t)
                | Minus -> Copy (v, ANum (n1 - n2))::(evaluate_vars t)
                | Div -> Copy (v, ANum (n1 / n2))::(evaluate_vars t)
                | Times -> Copy (v, ANum (n1 * n2))::(evaluate_vars t))
        | (JumpIfNeg (l, ANum n))::t ->
                if n < 0 then (Jump l)::(evaluate_vars (List.tl t))
                else evaluate_vars t
        | (JumpIfZero (l, ANum n))::t ->
                if n < 0 then (Jump l)::(evaluate_vars (List.tl t))
                else evaluate_vars t
        | _ -> c

(* Optimize code. You can define other helper functions if you want, just put
them above this function. *)
let rec optimize (c: code) =
    let rec optimize_rec rc =
        let evaluated_code = evaluate_vars rc in
        match evaluated_code with
        | [] -> []
        | (Copy (v, ANum n))::t ->
                if (count_assign v c) = 1 then optimize_rec (propagating v n t)
                else (Copy (v, ANum n))::(optimize_rec t)
        | h::t -> h::(optimize_rec t)
    in
    fix optimize_rec c in

open Tac
open Env
open Util

exception InterpretError of string

let interpwlen (c: code) env : int * int =
  let labels = labels c in
  let jump l =
    match VMap.find_opt l labels with
    | Some n -> n
    | None -> raise (InterpretError ("unbound label " ^ l))
  in
  let get_val a env =
    match a with
    | ANum n -> n
    | AVar v ->
       (match env_find env v with
        | Some n -> n
        | None -> raise (InterpretError ("unbound variable " ^ v)))
  in
  let do_binop o d s1 s2 env =
    let v1 = get_val s1 env in
    let v2 = get_val s2 env in
    env_add env d
      (match o with
       | Plus -> v1 + v2
       | Minus -> v1 - v2
       | Div -> v1 / v2
       | Times -> v1 * v2)
  in
  let rec interp_rec n env ctr =
    try
      (match List.nth c n with
       | Label l -> interp_rec (n + 1) env (ctr + 1)
       | Binop (d, o, s1, s2) ->
          interp_rec (n + 1) (do_binop o d s1 s2 env) (ctr + 1)
       | Copy (d, s) ->
          interp_rec (n + 1) (env_add env d (get_val s env)) (ctr + 1)
       | Jump l -> interp_rec (jump l) env (ctr + 1)
       | JumpIfZero (l, a) ->
          interp_rec
            (if get_val a env = 0 then jump l else n + 1)
            env
            (ctr + 1)
       | JumpIfNeg (l, a) ->
          interp_rec
            (if get_val a env < 0 then jump l else n + 1)
            env
            (ctr + 1)
       | Ret a -> (get_val a env, ctr + 1))
    with
      Failure _
    | Invalid_argument _ -> raise (InterpretError "segmentation fault")
  in
  interp_rec 0 env 0

let interp c env = fst (interpwlen c env)

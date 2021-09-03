open Tac
open Env

let get_val a env =
  match a with
  | ANum n -> Some n
  | AVar v -> env_find env v

let labels (c: code) : int VMap.t =
  snd
    (List.fold_left (fun (i, m) instr ->
         match instr with
         | Label l -> (i + 1, VMap.add l i m)
         | _ -> (i + 1, m))
       (0, VMap.empty)
       c)


let jumps (c: code) : int VMap.t =
  let (_, m, _) =
    (List.fold_left (fun (i, m, curb) instr ->
         match instr with
         | Jump l
           | JumpIfZero (l, _)
           | JumpIfNeg (l, _) when l <> curb -> (i + 1, VMap.add l i m, curb)
         | Label l -> (i + 1, m, l)
         | _ -> (i + 1, m, curb))
       (0, VMap.empty, "")
       c)
  in m

let uses (c: code) : int VMap.t =
  snd
    (List.fold_left (fun (i, m) instr ->
         match instr with
         | Copy (_, AVar x)
           | Ret (AVar x)
           | JumpIfZero (_, AVar x)
           | JumpIfNeg (_, AVar x)
           | Binop (_, _, AVar x, ANum _)
           | Binop (_, _, ANum _, AVar x) -> (i + 1, VMap.add x i m)
         | Binop (_, _, AVar x, AVar y) ->
            (i + 1, VMap.add x i (VMap.add y i m))
         | _ -> (i + 1, m))
       (0, VMap.empty)
       c)

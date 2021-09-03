open Tac

module S =
  struct
    type t = string
    let compare = String.compare
  end

module VMap = Map.Make(S)

type env = int VMap.t

let empty_env = VMap.empty

let env_add (e: env) (x: string) (v: int) = VMap.add x v e
let env_union (e1: env) (e2: env) =
  VMap.merge (fun _ a b ->
      match (a, b) with
      | (a, None) -> a
      | _ -> b)
    e1
    e2
let env_find (e: env) (x: string) =
  VMap.find_opt x e
let env_remove (e: env) (x: string) =
  VMap.remove x e


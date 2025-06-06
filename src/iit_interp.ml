(* IITRAN Interpreter *)
(* IIT CS 443, Fall 2022 *)
(* Project 0 *)

open IITRAN.Ast

exception RuntimeError of loc * string

exception Unimplemented

module Env = Varmap
module Pprint = IITRAN.Print

type value = int
type env = (value * typ) Env.t
let empty_env : env = Env.empty

let val_of_const =
  function CChar c -> (Char.code c, TCharacter)
         | CInt n -> (n, TInteger)

let to_log n = if n > 0 then 1 else 0
let log_of_bool = function true -> 1 | false -> 0

let do_bop b v1 v2 =
  match b with
  | BAdd -> (v1 + v2, TInteger)
  | BSub -> (v1 - v2, TInteger)
  | BMul -> (v1 * v2, TInteger)
  | BDiv -> (v1 / v2, TInteger)
  | BAnd -> (to_log (min v1 v2), TLogical)
  | BOr -> (to_log (max v1 v2), TLogical)
  | BGt -> (log_of_bool (v1 > v2), TLogical)
  | BGe -> (log_of_bool (v1 >= v2), TLogical)
  | BLt -> (log_of_bool (v1 < v2), TLogical)
  | BLe -> (log_of_bool (v1 <= v2), TLogical)
  | BNe -> (log_of_bool (v1 <> v2), TLogical)
  | BEq -> (log_of_bool (v1 = v2), TLogical)

let do_unop u v =
  match u with
  | UNeg -> (~- v, TInteger)
  | UNot -> (to_log (1 - v), TLogical)
  | UChar -> (v, TCharacter)
  | ULog -> (to_log v, TLogical)
  | UInt -> (v, TInteger)

let rec interp_exp (env: env) (exp: 'a exp) : int * typ * env =
  match exp.edesc with
  | EAssign ({edesc = EVar var; _}, rhs) ->
      let (value, typ, env') = (interp_exp env rhs) in
      (value, typ, (Env.add var (value, typ) env'))
  | EAssign (_, _) ->
      raise (RuntimeError (exp.eloc, "Left side of assignment not a variable"))
  | EConst c ->
      let (value, typ) = val_of_const c in
      (value, typ, env)
  | EBinop (op, lhs, rhs) ->
      let (lval, ltyp, lenv) = interp_exp env lhs in
      let (rval, rtyp, env') = interp_exp lenv rhs in
      let (res, typ) = do_bop op lval rval in
      (res, typ, env')
  | EUnop (op, exp) ->
      let (value, typ, env') = interp_exp env exp in
      let (res, typ') = do_unop op value in
      (res, typ', env')
  | EVar (var) ->
      (match (Env.find_opt var env) with
       | Some(value, typ) -> (value, typ, env)
       | None -> raise (RuntimeError (exp.eloc, (Printf.sprintf "Unbound variable: %s" var))))
  | _ -> raise (RuntimeError (exp.eloc, "Expression not implemented"))


exception Stop of env

let rec interp_stmt (env: env) (s: 'a stmt) : env =
  match s.sdesc with
  | SDecl (t, vars) ->
     List.fold_left (fun env v -> Env.add v (0, t) env) env vars
  | SDo ss ->
     List.fold_left interp_stmt env ss
  | SExp e -> let (_, _, env) = interp_exp env e in env
  | SIf (e, s1, s2o) ->
     let (v, _, env) = interp_exp env e in
     if v > 0 then
       interp_stmt env s1
     else
       (match s2o with
        | Some s2 -> interp_stmt env s2
        | None -> env
       )
  | SWhile (e, s) ->
     let (v, _, env) = interp_exp env e in
     if v > 0 then
       let env = interp_stmt env s in
       interp_stmt env (mk_stmt s.sloc (SWhile (e, s)))
     else env
  | SStop -> raise (Stop env)

let rec interp_prog (p: 'a stmt list) : env =
  try
    List.fold_left interp_stmt empty_env p
  with Stop e -> e

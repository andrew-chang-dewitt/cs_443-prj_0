exception RuntimeError of IITRAN.Ast.loc * string

module Env = Varmap
type value = int
type env = (value * IITRAN.Ast.typ) Env.t

val empty_env : env
val val_of_const : IITRAN.Ast.const -> int * IITRAN.Ast.typ

val interp_exp : env -> 'a IITRAN.Ast.exp -> value * IITRAN.Ast.typ * env
val interp_stmt : env -> 'a IITRAN.Ast.stmt -> env
val interp_prog : 'a IITRAN.Ast.stmt list -> env

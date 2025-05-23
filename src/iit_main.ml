(* IITRAN interpreter main *)
(* IIT CS 443, Fall 2022 *)
(* Stefan Muller *)

let fname = Sys.argv.(1)
let ch = open_in fname
let lexbuf = Lexing.from_channel ch
let prog =
  try IITRAN.Parser.prog IITRAN.Lexer.token lexbuf
  with _ -> Printf.eprintf "Syntax error.\n"; exit 1

let tprog = IITRAN.Typecheck.typecheck_prog prog
let result_env =
  try Iit_interp.interp_prog tprog
  with Iit_interp.RuntimeError ((sloc, eloc), s) ->
    Format.fprintf Format.std_formatter "%s--%s: %s\n"
      (IITRAN.Print.string_of_pos sloc)
      (IITRAN.Print.string_of_pos eloc)
      s;
    exit 1

let _ =
  try
    let (v, t) = Iit_interp.Env.find "result" result_env in
    IITRAN.Print.pprint_as_type Format.std_formatter v t;
    Format.print_newline ()
  with Not_found -> ()

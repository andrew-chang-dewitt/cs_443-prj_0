(lang dune 2.9)
(name cs443-proj0)
(version 0.1)
(using menhir 2.1)

(generate_opam_files true)

(package
 (name cs443-proj0)
 (synopsis "IITRAN Interpreter")
 (depends
  (ocaml (>= 4.14.2))
  menhir
  ppx_deriving))

# refresher: interpreters

this assignment utilizes a language called
miniIITRAN, a subset of
IITRAN<sup>[1][iitran-wikipedia]</sup>, to
introduce/refresh concepts of interpetors by
building an interpretor for the language.

## miniIITRAN specification

miniIITRAN's syntax can be expressed using BNF as follows:

```BNF
                 <digit> ::= 0-9
                 <alpha> ::= a-z,A-Z
              <alphanum> ::= <alpha> | <digit> | "-"
Identifiers         <id> ::= <alpha> <alphanum>*
Ident.Lists     <idlist> ::= <id> | <id>, <idlist>
Numbers            <num> ::= ["-"] <digit>+
Types              <typ> ::= INTEGER | CHARACTER | LOGICAL
Constants            <c> ::= <alpha> | <num>
Binary Operators   <bop> ::= "+" | "-" | "*"| "/" | "AND"
                           | "OR" | "<" | "<=" | ">"
                           | ">=" | "#" | "="
Unary Operators    <uop> ::= "~" | "NOT" | "CHAR"
                           | "LG" | "INT"
Expressions          <e> ::= <c> | <id> | <e> <bop> <e>
                           | <e> <- <e> | <uop> <e>
Statements           <s> ::= <e> | "STOP"
                           | "DO " <s>* "END" | "IF" <e> <s>
                           | "IF" <e> <s> "ELSE" <s>
                           | "WHILE" <e> <s>
Declarations         <d> ::= <typ> <idlist>
Program              <p> ::= <d>* <s>*
```

## assignment

this project comes with some utilities and datatypes implemented already, including pretty printing (in `iit_print.ml`) and an Abstract Syntax Tree (in `iit_ast.ml`). the assignment is to complete the interpreter implementation in `iit_interp.ml` using the given parser and AST.

running `make` will invoke `dune` to build the interpreter binary executable, which can be invoked on a given miniIITRAN source code file using `./iit <source>.iit`. example source files are given and can be used to test the implementation for correctness by running `make test`.

[iitran-wikipedia]: https://en.m.wikipedia.org/wiki/IITRAN

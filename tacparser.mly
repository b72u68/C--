%{
    open Tac
    let src1 (_, a, _) = a
    let src2 (_, _, a) = a
    let op (o, _, _) = o
%}

%token <int> NUM
%token <string> IDENT
%token PLUS MINUS TIMES DIV
%token EQUAL
%token COLON
%token RET
%token JUMP JNEG JZ
%token EOF EOL

%nonassoc EQUAL

%start code
%type <Tac.code> code

%%
addr:
  NUM                                      { ANum $1 }
| IDENT                                    { AVar $1 }
;

instr:
| IDENT COLON                            { Label $1 }
| IDENT EQUAL binop                      { Binop ($1, op $3, src1 $3, src2 $3) }
| IDENT EQUAL addr                       { Copy ($1, $3) }
| JUMP IDENT                             { Jump $2 }
| JZ IDENT addr                          { JumpIfZero ($2, $3) }
| JNEG IDENT addr                        { JumpIfNeg ($2, $3) }
| RET addr                               { Ret $2 }
;

binop:
| addr PLUS addr                         { (Plus, $1, $3) }
| addr MINUS addr                        { (Minus, $1, $3) }
| addr TIMES addr                        { (Times, $1, $3) }
| addr DIV addr                          { (Div, $1, $3) }
;

code:
| EOF                                      { [] }
| EOL code                                 { $2 }
| instr EOF                                { [$1] }
| instr EOL code                           { $1::$3 }
;

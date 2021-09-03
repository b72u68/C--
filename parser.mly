%{
    open Tac
%}

%token <int> NUM
%token <string> IDENT
%token PLUS MINUS TIMES DIV
%token AND OR
%token LT LE GT GE NE EQ
%token EQUAL
%token IF ELSE
%token LBRACE RBRACE
%token WHILE
%token LPAREN RPAREN
%token SEMI
%token RETURN
%token EOF

%nonassoc EQUAL
%left LT LE GT GE NE EQ
%left PLUS MINUS
%left TIMES DIV

%start prog
%type <Tac.stmt> prog

%%
iexpr:
  NUM                                      { Num $1 }
| IDENT                                    { Var $1 }
| iexpr PLUS iexpr                         { NBinop (Plus, $1, $3) }
| iexpr MINUS iexpr                        { NBinop (Minus, $1, $3) }
| iexpr TIMES iexpr                        { NBinop (Times, $1, $3) }
| iexpr DIV iexpr                          { NBinop (Div, $1, $3) }
| LPAREN iexpr RPAREN                      { $2 }
;

bexpr:
| bexpr AND bexpr                            { And ($1, $3) }
| bexpr OR bexpr                             { Or ($1, $3) }
| iexpr EQ iexpr                             { Relop (Eq, $1, $3) }
| iexpr LT iexpr                             { Relop (Lt, $1, $3) }
| iexpr LE iexpr                             { Relop (Le, $1, $3) }
| iexpr GT iexpr                             { Relop (Gt, $1, $3) }
| iexpr GE iexpr                             { Relop (Ge, $1, $3) }
| iexpr NE iexpr                             { Relop (Ne, $1, $3) }
| LPAREN bexpr RPAREN                        { $2 }
;

stmt:
| IDENT EQUAL iexpr SEMI                   { Assign ($1, $3) }
| IF bexpr block ELSE block                { If ($2, $3, Some $5) }
| IF bexpr block                           { If ($2, $3, None) }
| WHILE bexpr block                        { While ($2, $3) }
| RETURN iexpr SEMI                        { Return $2 }
;

stmts:
| stmt stmts                               { $1::$2 }
|                                          { [] }
;

block:
  stmt                                     { Block [$1] }
| LBRACE stmts RBRACE                      { Block $2 }
;

prog:
| stmts EOF                                { Block $1 }

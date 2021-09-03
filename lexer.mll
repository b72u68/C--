{

  open Parser
  exception Quit

}

let digit = ['0'-'9']
let identchar = ['a'-'z' 'A'-'Z' '\'' '_' '0'-'9']
let ident = ['a'-'z'] identchar*
let ws = [' ' '\t' '\n' '\r']

rule comment = parse
       | "\n" { token lexbuf }
       | _ { comment lexbuf}
and token = parse
       | ws { token lexbuf }
       | "//" { comment lexbuf }
       | digit+ as n { NUM (int_of_string n) }

       | "+" { PLUS }
       | "-" { MINUS }
       | "*" { TIMES }
       | "/" { DIV }
       | "&&" { AND }
       | "||" { OR }
       | "<=" { LE }
       | "<" { LT }
       | ">=" { GE }
       | ">" { GT }
       | "!=" { NE }
       | "==" { EQ }
             
       | "=" { EQUAL }

       | "if" { IF }
       | "else" { ELSE }

       | "while" { WHILE }

       | "return" { RETURN }

       | "(" { LPAREN }
       | ")" { RPAREN }

       | "{" { LBRACE }
       | "}" { RBRACE }

       | ";" { SEMI }
               
       | ident as s { IDENT s }

       | eof { EOF }

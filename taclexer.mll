{

  open Tacparser

}

let digit = ['0'-'9']
let identchar = ['a'-'z' 'A'-'Z' '\'' '_' '0'-'9']
let ident = ['a'-'z'] identchar*
let ws = [' ' '\t']

rule comment = parse
       | ['\n' '\r'] { token lexbuf }
       | _ { comment lexbuf}
and token = parse
       | ws { token lexbuf }
       | "//" { comment lexbuf }
       | '-'?digit+ as n { NUM (int_of_string n) }

       | "+" { PLUS }
       | "-" { MINUS }
       | "*" { TIMES }
       | "/" { DIV }
             
       | "=" { EQUAL }

       | "jump" { JUMP }
       | "jz" { JZ }
       | "jneg" { JNEG }

       | ":" { COLON }

       | "ret" { RET }
               
       | ident as s { IDENT s }

       | ['\n' '\r'] { EOL }

       | eof { EOF }
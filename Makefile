cmm: tac.ml parser.mly lexer.mll env.ml compile.ml interptac.ml printtac.ml main.ml util.ml optimize.ml
	ocamllex lexer.mll
	ocamlyacc parser.mly
	ocamlc -g -o cmm printtac.ml tac.ml parser.mli lexer.ml parser.ml env.ml compile.ml util.ml optimize.ml interptac.ml main.ml

tac: tac.ml tacparser.mly taclexer.mll env.ml interptac.ml maintac.ml util.ml
	ocamllex taclexer.mll
	ocamlyacc tacparser.mly
	ocamlc -g -o tac tac.ml tacparser.mli taclexer.ml tacparser.ml env.ml util.ml interptac.ml maintac.ml

leader: tac.ml tacparser.mly taclexer.mll env.ml interptac.ml maintac.ml util.ml leader.ml
	ocamllex taclexer.mll
	ocamlyacc tacparser.mly
	ocamlfind ocamlc -g -thread -linkpkg -package yojson -package unix -package lwt -package cohttp-async -package cohttp-lwt-unix -o leader tac.ml tacparser.mli taclexer.ml tacparser.ml env.ml util.ml interptac.ml leader.ml

clean:
	rm -f *.cmo *.cmi
	rm -f cmm
	rm -f tac
	rm -f lexer.ml
	rm -f parser.mli
	rm -f parser.ml
	rm -f taclexer.ml
	rm -f tacparser.mli
	rm -f tacparser.ml
	rm -f leader

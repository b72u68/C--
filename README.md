# C--

A compiler written in Ocaml for programming language C-- (C minus minus)

## Requirements

- Install Ocaml: [https://ocaml.org/learn/tutorials/up_and_running.html](https://ocaml.org/learn/tutorials/up_and_running.html).

## Instructions

- Generate Ocaml lexer and parser for compiler

```bash
make cmm && make tac
```

- To compile file (running this command will create new file with the same name
  with .tac at the end)

```bash
./cmm [filename]
```

- To run compiled file (.tac file)

```bash
./tac [filename]
```

- You can also use this command to compile and run file at the same time

```bash
python compile_cmm.py [filename]
```

## Features

- Simple mathematical calculations and operators: addition, subtraction,
  multiplication, division, and, or.
- Conditional statement: if - else.
- Loop: while loop.

> Sample cmm files are contained in `examples` directory.

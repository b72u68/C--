# C--

A compiler written in Ocaml for programming language C-- (C minus minus)

## Requirements

Install Ocaml: [https://ocaml.org/learn/tutorials/up_and_running.html](https://ocaml.org/learn/tutorials/up_and_running.html).

## Instructions

Generate Ocaml lexer and parser for compiler

```bash
make cmm && make tac
```

To compile file (running this command will create new file with the same name
with .tac at the end)

```bash
./cmm [filename]
```

To run compiled file (.tac file)

```bash
./tac [filename]
```

You can also use this command to compile and run file at the same time

```bash
python compile_cmm.py [filename]
```

## Features

> Sample cmm files are contained in `examples` directory.

- Simple mathematical calculations and operators: addition, subtraction,
  multiplication, division, and, or.
- Conditional statement: if - else.
- Loop: while loop.

### Expressions

Declare and return varibles/values.

```
x = 1;
return 1;
```

```
return (1 + 2) - 3 * 4 / 2;

```

```
a = 1 + 2;
b = a * 3;
c = (b + 1) / 2 + a;
return (c - 1);
```

### Conditional statement

If-else statement

```
a = 5;
if (a < 10)
{
  b = 1;
}
else
{
  b = 2;
}

return b;
```

```

if ((1 < 2) && ((5 < 8) || (2 < 1)))
{
  if ((2 < 1) && (0 <= 1))
  {
    b = 1;
  }
  else
  {
    b = 2;
  }
}
else
{
  b = 3;
}
return b;

```

### Loop

While loop

```
n = 5;
fact = 1;
while (n >= 1)
{
  fact = fact * n;
  n = n - 1;
}
return fact;
```

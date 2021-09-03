#!/usr/bin/python3.9

import sys
import subprocess

if len(sys.argv) < 1 or len(sys.argv) > 2:
    print("Enter filename: ")
else:
    file = sys.argv[1]
    print(f'Compiling {file}...')
    subprocess.run(["./cmm", file])
    print("Program compiled successfully")
    print(f'Running {file[:-3]}.tac...')
    subprocess.run(["./tac", file[:-3] + "tac"])

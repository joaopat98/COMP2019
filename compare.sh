#!/bin/bash
file1=$1
file2=$2
flex src/gocompiler.l
clang lex.yy.c
./a.out -l < $file1 > output
diff output $file2
rm lex.yy.c a.out output

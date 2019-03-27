#!/bin/bash
file1=$1
file2=$2
flag=$3
flex src/gocompiler.l
bison -y -d src/gocompiler.y
clang -Wall y.tab.c lex.yy.c
./a.out $flag < $file1 > output
diff output $file2
rm y.tab.c lex.yy.c a.out output

#!/bin/bash
file1=$1
flag=$2
flex gocompiler.l
bison -y -d gocompiler.y
clang -Wall code_gen.c lex.yy.c nodes.c semantics.c sym_types.c symtab.c y.tab.c
./a.out $flag < $file1 > out.ll
llc out.ll
clang out.s
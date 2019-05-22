#!/bin/bash
file1=$1
flag=$2
flex gocompiler.l
bison -y -d gocompiler.y
clang -Wall *.c
./a.out $flag < $file1 > out.ll
llc out.ll
clang out.s
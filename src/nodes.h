#include "token.h"
#include "sym_types.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#ifndef NODES_H
#define NODES_H 1

typedef enum
{
    Program,
    VarDecl,
    FuncDecl,
    FuncHeader,
    FuncParams,
    FuncBody,
    ParamDecl,
    Block,
    If,
    For,
    Return,
    Call,
    Print,
    ParseArgs,
    Or,
    And,
    Eq,
    Ne,
    Lt,
    Gt,
    Le,
    Ge,
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Not,
    Minus,
    Plus,
    Assign,
    Int,
    Float32,
    Bool,
    String,
    IntLit,
    RealLit,
    Id,
    StrLit
} node_type;

typedef struct node Node;

typedef struct node
{
    int line;
    int col;
    node_type type;
    sym_type symbol_type;
    char *val;
    char error[500];
    Node *next;
    Node *children;
} node_t;

Node *new_node(int type, tokeninfo token);

Node *new_empty_node(int type);

void append_child(Node *parent, Node *child);

void unshift_child(Node *parent, Node *child);

void add_neighbour(Node *child, Node *new_child);

int count(Node *n);

Node *get_child(Node *n, node_type type);

void print_errors(Node *n);

void print_tree(Node *n, int level, bool to_print);

#endif
#include "nodes.h"
#include "stdlib.h"
#include "stdio.h"
#include "sym_types.h"

#ifndef SYMTAB_H
#define SYMTAB_H 1

typedef struct type_node TypeNode;

typedef struct type_node
{
    sym_type type;
    TypeNode *next;
} TypeNode;

typedef struct sym Symbol;

typedef struct sym
{
    sym_type type;
    char name[100];
    bool is_func;
    bool was_used;
    Node *declaration;
    TypeNode *params;
    Symbol *next;
} sym_t;

typedef struct sc Scope;

typedef struct sc
{
    char name[100];
    bool is_func;
    sym_type return_type;
    int num_params;
    Symbol *ref_sym;
    Symbol *symbols;
    Scope *next;
} sc_t;

void add_scope(Scope *root, Scope *scope);

Scope *new_scope(char *name, bool is_func, sym_type return_type, Symbol *ref_sym);

Symbol *add_sym(Scope *scope, Symbol *symbol);

Symbol *add_param(Scope *scope, Symbol *symbol);

Symbol *new_symbol(sym_type type, char *name, Node *declaration);

Symbol *new_func(sym_type type, char *name, Node *declaration);

void add_func_param(Symbol *symbol, sym_type param);

Symbol *get_symbol(Scope *scope, char *name);

sym_type get_node_type(Node *n);

void print_scopes(Scope *scope);

#endif
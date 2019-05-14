#ifndef SYMTAB_H
#define SYMTAB_H 1

#include "nodes.h"
#include "stdlib.h"
#include "stdio.h"
#include "sym_types.h"

void add_scope(Scope *root, Scope *scope);

Scope *new_scope(char *name, bool is_func, sym_type return_type, Symbol *ref_sym, Node *body);

Symbol *add_sym(Scope *scope, Symbol *symbol);

Symbol *add_param(Scope *scope, Symbol *symbol);

Symbol *new_symbol(sym_type type, char *name, Node *declaration);

Symbol *new_func(sym_type type, char *name, Node *declaration);

void add_func_param(Symbol *symbol, sym_type param);

Symbol *get_symbol(Scope *scope, char *name);

sym_type get_node_type(Node *n);

const char *type_str(sym_type type);

void print_scopes(Scope *scope);

#endif
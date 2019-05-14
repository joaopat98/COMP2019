#include "symtab.h"
#include "nodes.h"
#include "string.h"

#ifndef SEMANTICS_H
#define SEMANTICS_H 1

bool parse_node(Node *n, Scope *local, Scope *global);

bool parse_program(Scope *global);

int parse_global(Node *n, Scope *global);

#endif
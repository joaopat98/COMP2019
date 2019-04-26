#include "symtab.h"
#include "nodes.h"

#ifndef SEMANTICS_H
#define SEMANTICS_H 1

void parse_node(Node *n, Scope *scope, Scope *global);

#endif
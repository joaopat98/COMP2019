#include "semantics.h"

void parse_node(Node *n, Scope *scope, Scope *global)
{
    switch (n->type)
    {
    case Program:
        for (Node *ptr = n->children; ptr != NULL; ptr = ptr->next)
        {
            parse_node(ptr, scope, global);
        }
        break;
    case VarDecl:
        add_sym(scope, new_symbol(get_node_type(n->children), n->children->next->val, n->children->next));
        break;
    case FuncDecl:
    {
        Node *header = n->children;
        Node *body = header->next;
        Symbol *func = new_func(get_node_type(header->children->next), header->children->val, header->children);
        add_sym(global, func);
        Scope *func_scope = new_scope(func->name, true, func->type, func);
        for (Node *param = get_child(header, FuncParams)->children; param != NULL; param = param->next)
        {
            Symbol *result = add_param(func_scope, new_symbol(get_node_type(param->children), param->children->next->val, param->children->next));
            if (result == NULL)
            {
                add_func_param(func, get_node_type(param->children));
            }
        }
        add_scope(global, func_scope);
        for (Node *ptr = body->children; ptr != NULL; ptr = ptr->next)
        {
            parse_node(ptr, func_scope, global);
        }
        break;
    }
    default:
        break;
    }
}
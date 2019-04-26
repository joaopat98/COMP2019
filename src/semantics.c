#include "semantics.h"

bool parse_node(Node *n, Scope *local, Scope *global)
{
    bool error = false;
    switch (n->type)
    {
    case Program:
        for (Node *ptr = n->children; ptr != NULL; ptr = ptr->next)
        {
            error = error || parse_node(ptr, local, global);
        }
        break;
    case VarDecl:
    {
        Node *id_node = n->children->next;
        if (add_sym(local, new_symbol(get_node_type(n->children), id_node->val, id_node)) != NULL)
        {
            sprintf(id_node->error, "Symbol %s already defined\n", id_node->val);
            error = true;
        }
    }
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
            error = error || parse_node(ptr, func_scope, global);
        }
    }
    break;
    default:
        break;
    }
    return error;
}
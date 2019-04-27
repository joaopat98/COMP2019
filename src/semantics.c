#include "semantics.h"

bool parse_expr(Node *n, Scope *local, Scope *global)
{
    bool error = false;
    Node *first, *second;
    switch (n->type)
    {
    case Or:
    case And:
        first = n->children;
        second = n->children->next;
        error = parse_expr(first, local, global) || parse_expr(second, local, global);
        if (first->symbol_type != bool_type || second->symbol_type != bool_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot  be  applied  to  types %s, %s\n", n->val, type_str(first->symbol_type), type_str(second->symbol_type));
            n->symbol_type = undef;
        }
        else
        {
            n->symbol_type = bool_type;
        }
        break;
    case Lt:
    case Gt:
    case Le:
    case Ge:
    case Add:
    case Sub:
    case Mul:
    case Div:
        first = n->children;
        second = n->children->next;
        error = parse_expr(first, local, global) || parse_expr(second, local, global);
        if (first->symbol_type == bool_type || second->symbol_type == bool_type || first->symbol_type != second->symbol_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot  be  applied  to  types %s, %s\n", n->val, type_str(first->symbol_type), type_str(second->symbol_type));
            n->symbol_type = undef;
        }
        else
        {
            n->symbol_type = first->symbol_type;
        }
        break;
    case Mod:
        first = n->children;
        second = n->children->next;
        error = parse_expr(first, local, global) || parse_expr(second, local, global);
        if (first->symbol_type != integer_type || second->symbol_type != integer_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot  be  applied  to  types %s, %s\n", n->val, type_str(first->symbol_type), type_str(second->symbol_type));
            n->symbol_type = undef;
        }
        else
        {
            n->symbol_type = integer_type;
        }
        break;
    case Not:
        error = parse_expr(n->children, local, global);
        if (n->children->symbol_type != bool_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot  be  applied  to  type %s\n", n->val, type_str(n->children->symbol_type));
            n->symbol_type = undef;
        }
        else
        {
            n->symbol_type = bool_type;
        }
        break;
    case Minus:
    case Plus:
        error = parse_expr(n->children, local, global);
        if (n->children->symbol_type == bool_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot  be  applied  to  type %s\n", n->val, type_str(n->children->symbol_type));
            n->symbol_type = undef;
        }
        else
        {
            n->symbol_type = bool_type;
        }
        break;
    case IntLit:
        n->symbol_type = integer_type;
        break;
    case RealLit:
        n->symbol_type = float32_type;
        break;
    case Id:
    {
        Symbol *id_sym = get_symbol(local, n->val);
        if (id_sym == NULL)
            id_sym = get_symbol(global, n->val);
        if (id_sym == NULL || id_sym->is_func)
        {
            error = true;
            sprintf(n->error, "Cannot find symbol %s\n", n->val);
        }
        else
        {
            n->symbol_type = id_sym->type;
        }
    }
    break;
    case Call:
    {
        Symbol *func_sym = get_symbol(global, n->children->val);
        Node *call_param;
        for (call_param = n->children->next; call_param != NULL; call_param = call_param->next)
        {
            error = error || parse_expr(call_param, local, global);
        }
        error = error || func_sym == NULL || !(func_sym->is_func);
        if (!error)
        {
            TypeNode *func_param = func_sym->params;
            call_param = n->children->next;
            while (func_param != NULL && call_param != NULL)
            {
                if (func_param == NULL || call_param == NULL || func_param->type != call_param->symbol_type)
                {
                    error = true;
                    break;
                }
                func_param = func_param->next;
                call_param = call_param->next;
            }
        }
        if (error)
        {
            sprintf(n->error, "Cannot find symbol %s(", func_sym->name);
            if (call_param != NULL)
            {
                sprintf(n->error + strlen(n->error), "%s", type_str(call_param->symbol_type));
                for (call_param = call_param->next; call_param != NULL; call_param = call_param->next)
                {
                    sprintf(n->error + strlen(n->error), ",%s", type_str(call_param->symbol_type));
                }
            }
            n->symbol_type = undef;
            break;
        }
        else
        {
            n->symbol_type = func_sym->type;
        }
    }
    break;
    default:
        break;
    }
    return error;
}

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
    case Or:
    case And:
    case Lt:
    case Gt:
    case Le:
    case Ge:
    case Add:
    case Sub:
    case Mul:
    case Div:
    case Mod:
    case Not:
    case Minus:
    case Plus:
    case IntLit:
    case RealLit:
    case Id:
    case Call:
        error = parse_expr(n, local, global);
        break;
    default:
        break;
    }
    return error;
}
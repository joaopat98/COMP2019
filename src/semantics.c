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
            sprintf(n->error, "Operator %s cannot be applied to types %s, %s\n", n->val, type_str(first->symbol_type), type_str(second->symbol_type));
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
        n->symbol_type = bool_type;
        first = n->children;
        second = n->children->next;
        error = parse_expr(first, local, global) || parse_expr(second, local, global);
        if (first->symbol_type == bool_type || second->symbol_type == bool_type || first->symbol_type != second->symbol_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot be applied to types %s, %s\n", n->val, type_str(first->symbol_type), type_str(second->symbol_type));
        }
        break;
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
            sprintf(n->error, "Operator %s cannot be applied to types %s, %s\n", n->val, type_str(first->symbol_type), type_str(second->symbol_type));
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
            sprintf(n->error, "Operator %s cannot be applied to types %s, %s\n", n->val, type_str(first->symbol_type), type_str(second->symbol_type));
            n->symbol_type = undef;
        }
        else
        {
            n->symbol_type = integer_type;
        }
        break;
    case Not:
        n->symbol_type = bool_type;
        error = parse_expr(n->children, local, global);
        if (n->children->symbol_type != bool_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot be applied to type %s\n", n->val, type_str(n->children->symbol_type));
        }
        break;
    case Eq:
    case Ne:
        n->symbol_type = bool_type;
        first = n->children;
        second = n->children->next;
        error = parse_expr(first, local, global) || parse_expr(second, local, global);
        if (first->symbol_type != second->symbol_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot be applied to types %s, %s\n", n->val, type_str(first->symbol_type), type_str(second->symbol_type));
        }
        break;
    case Minus:
    case Plus:
        error = parse_expr(n->children, local, global);
        if (n->children->symbol_type == bool_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot be applied to type %s\n", n->val, type_str(n->children->symbol_type));
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
        Node *call_param;
        for (call_param = n->children->next; call_param != NULL; call_param = call_param->next)
        {
            error = parse_expr(call_param, local, global) || error;
        }
        Symbol *func_sym = get_func(global, n->children->val, n->children->next);
        error = error || func_sym == NULL || !(func_sym->is_func);
        if (!error)
        {
            n->children->symbol = func_sym;
            n->symbol_type = func_sym->type;
        }
        else
        {
            call_param = n->children->next;
            sprintf(n->children->error, "Cannot find symbol %s(", n->children->val);
            if (call_param != NULL)
            {
                sprintf(n->children->error + strlen(n->children->error), "%s", type_str(call_param->symbol_type));
                for (call_param = call_param->next; call_param != NULL; call_param = call_param->next)
                {
                    sprintf(n->children->error + strlen(n->children->error), ",%s", type_str(call_param->symbol_type));
                }
            }
            sprintf(n->children->error + strlen(n->children->error), ")\n");
            n->symbol_type = undef;
            break;
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
    Node *id_node, *header, *body;
    Symbol *func;
    Scope *func_scope;
    switch (n->type)
    {
    case Program:
        for (Node *ptr = n->children; ptr != NULL; ptr = ptr->next)
        {
            error = parse_node(ptr, local, global) || error;
        }
        break;
    case VarDecl:
        id_node = n->children->next;
        if (add_sym(local, new_symbol(get_node_type(n->children), id_node->val, id_node)) != NULL)
        {
            sprintf(id_node->error, "Symbol %s already defined\n", id_node->val);
            error = true;
        }
        break;
    case FuncDecl:
        header = n->children;
        body = header->next;
        func = new_func(get_node_type(header->children->next), header->children->val, header->children);
        func_scope = new_scope(func->name, true, func->type, func);
        for (Node *param = get_child(header, FuncParams)->children; param != NULL; param = param->next)
        {
            Symbol *result = add_param(func_scope, new_symbol(get_node_type(param->children), param->children->next->val, param->children->next));
            if (result == NULL)
            {
                add_func_param(func, get_node_type(param->children));
            }
        }
        if (add_func(global, func) == NULL)
        {
            add_scope(global, func_scope);
            for (Node *ptr = body->children; ptr != NULL; ptr = ptr->next)
            {
                error = parse_node(ptr, func_scope, global) || error;
            }
        }
        else
        {
            sprintf(header->children->error, "Symbol %s(", header->children->val);
            TypeNode *param = func->params;
            if (param != NULL)
            {
                sprintf(header->children->error + strlen(header->children->error), "%s", type_str(param->type));
                for (param = param->next; param != NULL; param = param->next)
                {
                    sprintf(header->children->error + strlen(header->children->error), ",%s", type_str(param->type));
                }
            }

            sprintf(header->children->error + strlen(header->children->error), ") already defined\n");
            error = true;
        }

        break;

    case Assign:
        error = parse_expr(n->children->next, local, global);
        id_node = n->children;
        error = parse_expr(id_node, local, global) || error;
        if (id_node->symbol_type == undef || id_node->symbol_type != n->children->next->symbol_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot be applied to types %s, %s\n", n->val, type_str(id_node->symbol_type), type_str(n->children->next->symbol_type));
            n->symbol_type = undef;
        }

        break;
    case For:
        if (count(n->children) > 1)
        {
            error = parse_expr(n->children, local, global);
            if (n->children->symbol_type != bool_type)
            {
                n->line = n->children->line;
                n->col = n->children->col;
                error = true;
                sprintf(n->error, "Incompatible type %s in for statement\n", type_str(n->children->symbol_type));
                n->symbol_type = undef;
            }
            for (Node *ptr = n->children->next->children; ptr != NULL; ptr = ptr->next)
            {
                error = parse_node(ptr, local, global) || error;
            }
        }
        else
        {
            for (Node *ptr = n->children->next->children; ptr != NULL; ptr = ptr->next)
            {
                error = parse_node(ptr, local, global) || error;
            }
        }
        break;
    case If:
        error = parse_expr(n->children, local, global);
        if (n->children->symbol_type != bool_type)
        {
            n->line = n->children->line;
            n->col = n->children->col;
            error = true;
            sprintf(n->error, "Incompatible type %s in if statement\n", type_str(n->children->symbol_type));
            n->symbol_type = undef;
        }
        for (Node *ptr = n->children->next->children; ptr != NULL; ptr = ptr->next)
        {
            error = parse_node(ptr, local, global) || error;
        }
        if (n->children->next->next != NULL)
        {
            for (Node *ptr = n->children->next->children; ptr != NULL; ptr = ptr->next)
            {
                error = parse_node(ptr, local, global) || error;
            }
        }
        break;
    case Return:
        if (n->children != NULL)
        {
            error = parse_expr(n->children, local, global);
        }
        break;
    case Print:
        error = parse_expr(n->children, local, global);
        break;
    case ParseArgs:
        n->symbol_type = integer_type;
        error = parse_expr(n->children, local, global) || parse_expr(n->children->next, local, global);
        if (n->children->symbol_type != integer_type)
        {
            sprintf(n->error, "Operator = cannot be applied to types %s, int\n", type_str(n->children->symbol_type));
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
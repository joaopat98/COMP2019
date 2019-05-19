#include "semantics.h"

bool parse_expr(Node *n, Scope *local, Scope *global)
{
    bool error = false;
    bool suberror = false;
    bool left_error = false, right_error = false;
    Node *first, *second;
    switch (n->type)
    {
    case Or:
    case And:
        n->symbol_type = bool_type;
        first = n->children;
        second = n->children->next;
        left_error = parse_expr(first, local, global)
        right_error = parse_expr(second, local, global);
        error = left_error || right_error;
        if (first->symbol_type != bool_type || second->symbol_type != bool_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot be applied to types %s, %s\n", n->val, type_str(first->symbol_type), type_str(second->symbol_type));
        }
        break;
    case Lt:
    case Gt:
    case Le:
    case Ge:
        n->symbol_type = bool_type;
        first = n->children;
        second = n->children->next;
        left_error = parse_expr(first, local, global)
        right_error = parse_expr(second, local, global);
        error = left_error || right_error;
        if (!is_numeric(first->symbol_type) || !is_numeric(second->symbol_type))
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
		left_error = parse_expr(first, local, global)
        right_error = parse_expr(second, local, global);
        error = left_error || right_error;
        if (first->symbol_type == string_type && second->symbol_type == string_type)
        {
            n->symbol_type = integer_type;
            break;
        }

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
        left_error = parse_expr(first, local, global)
        right_error = parse_expr(second, local, global);
        error = left_error || right_error;
        if (first->symbol_type != integer_type  || second->symbol_type != integer_type)
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
        left_error = parse_expr(first, local, global)
        right_error = parse_expr(second, local, global);
        error = left_error || right_error;
        if (!(is_numeric(first->symbol_type) && is_numeric(second->symbol_type)) && first->symbol_type != second->symbol_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot be applied to types %s, %s\n", n->val, type_str(first->symbol_type), type_str(second->symbol_type));
        }
        break;
    case Minus:
    case Plus:
        error = parse_expr(n->children, local, global);
        if (n->children->symbol_type == bool_type || n->children->symbol_type == string_type)
        {
            error = true;
            sprintf(n->error, "Operator %s cannot be applied to type %s\n", n->val, type_str(n->children->symbol_type));
            n->symbol_type = undef;
        }
        else
        {
            n->symbol_type = n->children->symbol_type;
        }
        break;
    case IntLit:
        n->symbol_type = integer_type;
        if (strlen(n->val) > 1 && n->val[0] == '0' && n->val[1] != 'x' && n->val[1] != 'X')
        {
            for (int i = 1; i < strlen(n->val); i++)
            {
                if (n->val[i] - '0' > 7)
                {
                    error = true;
                    sprintf(n->error, "Invalid octal constant: %s\n", n->val);
                }
            }
        }

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
            n->symbol_type = undef;
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
            suberror = parse_expr(call_param, local, global) || suberror;
        }
        error = error || func_sym == NULL || !(func_sym->is_func);
        if (!error)
        {
            TypeNode *func_param = func_sym->params;
            call_param = n->children->next;
            while (func_param != NULL || call_param != NULL)
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
        else
        {suberror
            n->children->symbol = func_sym;
            n->symbol_type = func_sym->type == none ? no_type : func_sym->type;
        }
        error = error || suberror;
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
    Node *id_node;
    switch (n->type)
    {
    case VarDecl:
        id_node = n->children->next;
        if (add_sym(local, new_symbol(get_node_type(n->children), id_node->val, id_node)) != NULL)
        {
            sprintf(id_node->error, "Symbol %s already defined\n", id_node->val);
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
        else
        {
            n->symbol_type = n->children->symbol_type;
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
            for (Node *ptr = n->children->next->next->children; ptr != NULL; ptr = ptr->next)
            {
                error = parse_node(ptr, local, global) || error;
            }
        }
        break;
    case Return:
        if (n->children != NULL)
        {
            error = parse_expr(n->children, local, global);
            if (n->children->symbol_type != local->return_type)
            {
                error = true;
                n->line = n->children->line;
                n->col = n->children->col;
                sprintf(n->error, "Incompatible type %s in return statement\n", type_str(n->children->symbol_type));
            }
        }
        else if (local->return_type != none)
        {
            error = true;
            sprintf(n->error, "Incompatible type none in return statement\n");
        }
        break;
    case Print:
        error = parse_expr(n->children, local, global);
        break;
    case ParseArgs:
        n->symbol_type = integer_type;
        error = parse_expr(n->children, local, global) || parse_expr(n->children->next, local, global);
        if (n->children->symbol_type != integer_type || n->children->next->symbol_type != integer_type)
        {
            sprintf(n->error, "Operator strconv.Atoi cannot be applied to types %s, %s\n", type_str(n->children->symbol_type), type_str(n->children->next->symbol_type));
        }
        break;
    case Block:
        for (Node *ptr = n->children; ptr != NULL; ptr = ptr->next)
        {
            error = parse_node(ptr, local, global) || error;
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

bool parse_program(Scope *global)
{
    bool error = false;
    for (Scope *ptr = global->next; ptr != NULL; ptr = ptr->next)
    {
        for (Node *body_ptr = ptr->body->children; body_ptr != NULL; body_ptr = body_ptr->next)
        {
            error = parse_node(body_ptr, ptr, global) || error;
        }
        int i = 0;
        for (Symbol *var = ptr->symbols; var != NULL; var = var->next)
        {
            if (!(var->was_used) && i >= ptr->num_params)
            {
                error = true;
                sprintf(var->declaration->error, "Symbol %s declared but never used\n", var->name);
            }
            i++;
        }
    }
    return error;
}

int parse_global(Node *n, Scope *global)
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
            error = parse_global(ptr, global) || error;
        }
        break;
    case VarDecl:
        id_node = n->children->next;
        if (add_sym(global, new_symbol(get_node_type(n->children), id_node->val, id_node)) != NULL)
        {
            sprintf(id_node->error, "Symbol %s already defined\n", id_node->val);
            error = true;
        }
        break;
    case FuncDecl:
        header = n->children;
        body = header->next;
        func = new_func(get_node_type(header->children->next), header->children->val, header->children);
        if (add_sym(global, func) == NULL)
        {
            func_scope = new_scope(func->name, true, func->type, func, body);
            for (Node *param = get_child(header, FuncParams)->children; param != NULL; param = param->next)
            {
                Symbol *result = add_param(func_scope, new_symbol(get_node_type(param->children), param->children->next->val, param->children->next));
                add_func_param(func, get_node_type(param->children));
                if (result != NULL)
                {
                    error = true;
                    sprintf(param->children->next->error, "Symbol %s already defined\n", param->children->next->val);
                }
            }
            add_scope(global, func_scope);
        }
        else
        {
            sprintf(header->children->error, "Symbol %s already defined\n", header->children->val);
            error = true;
        }
        
        break;
    default:
        break;
    }
    return error;
}

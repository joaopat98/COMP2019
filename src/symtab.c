#include "symtab.h"

void add_scope(Scope *root, Scope *scope)
{
    Scope *ptr;
    for (ptr = root; ptr->next != NULL; ptr = ptr->next)
        ;
    ptr->next = scope;
}

Scope *new_scope(char *name, bool is_func, sym_type return_type, Symbol *ref_sym)
{
    Scope *scope = (Scope *)malloc(sizeof(Scope));
    strcpy(scope->name, name);
    scope->is_func = is_func;
    scope->return_type = return_type;
    scope->num_params = 0;
    scope->symbols = NULL;
    scope->next = NULL;
    scope->ref_sym = ref_sym;
    return scope;
}

Symbol *add_sym(Scope *scope, Symbol *symbol)
{
    if (scope->symbols == NULL)
    {
        scope->symbols = symbol;
    }
    else
    {
        Symbol *ptr = scope->symbols;
        while (true)
        {
            if (!strcmp(ptr->name, symbol->name))
                return ptr;
            if (ptr->next == NULL)
                break;
            ptr = ptr->next;
        }
        ptr->next = symbol;
    }
    return NULL;
}

Symbol *add_func(Scope *scope, Symbol *func)
{
    if (scope->symbols == NULL)
    {
        scope->symbols = func;
    }
    else
    {
        Symbol *ptr = scope->symbols;
        while (true)
        {
            if (!strcmp(ptr->name, func->name))
            {
                TypeNode *first = ptr->params;
                TypeNode *second = func->params;
                bool same = true;
                while (first != NULL || second != NULL)
                {
                    if (first == NULL || second == NULL || first->type != second->type)
                    {
                        same = false;
                        break;
                    }
                    first = first->next;
                    second = second->next;
                }
                if (same)
                    return ptr;
            }
            if (ptr->next == NULL)
                break;
            ptr = ptr->next;
        }
        ptr->next = func;
    }
    return NULL;
}

Symbol *add_param(Scope *scope, Symbol *symbol)
{
    Symbol *sym = add_sym(scope, symbol);
    if (sym == NULL)
        scope->num_params++;
    return sym;
}

Symbol *new_symbol(sym_type type, char *name, Node *declaration)
{
    Symbol *symbol = (Symbol *)malloc(sizeof(Symbol));
    strcpy(symbol->name, name);
    symbol->type = type;
    symbol->declaration = declaration;
    symbol->next = NULL;
    symbol->is_func = false;
    symbol->was_used = false;
    symbol->params = NULL;
    symbol->next = NULL;
    return symbol;
}

Symbol *new_func(sym_type type, char *name, Node *declaration)
{
    Symbol *symbol = new_symbol(type, name, declaration);
    symbol->is_func = true;
    return symbol;
}

void add_func_param(Symbol *symbol, sym_type param)
{
    TypeNode *new_param = (TypeNode *)malloc(sizeof(TypeNode));
    new_param->type = param;
    if (symbol->params == NULL)
    {
        symbol->params = new_param;
    }
    else
    {
        TypeNode *ptr;
        for (ptr = symbol->params; ptr->next != NULL; ptr = ptr->next)
            ;
        ptr->next = new_param;
    }
}

Symbol *get_symbol(Scope *scope, char *name)
{
    Symbol *ptr;
    for (ptr = scope->symbols; ptr != NULL; ptr = ptr->next)
    {
        if (!strcmp(ptr->name, name))
        {
            ptr->was_used = true;
            return ptr;
        }
    }
    return NULL;
}

Symbol *get_func(Scope *scope, char *name, Node *params)
{
    Symbol *ptr;
    for (ptr = scope->symbols; ptr != NULL; ptr = ptr->next)
    {
        if (!strcmp(ptr->name, name))
        {
            TypeNode *first = ptr->params;
            Node *second = params;
            bool same = true;
            while (first != NULL && second != NULL)
            {
                if (first == NULL || second == NULL || first->type != second->symbol_type)
                {
                    same = false;
                    break;
                }
                if (same)
                    return ptr;
            }
            if (same)
            {
                ptr->was_used = true;
                return ptr;
            }
        }
    }
    return NULL;
}

sym_type get_node_type(Node *n)
{
    switch (n->type)
    {
    case Int:
        return integer_type;
    case Float32:
        return float32_type;
    case Bool:
        return bool_type;
    case String:
        return string_type;
    default:
        return none;
    }
}

void print_scope(Scope *scope)
{
    if (scope->is_func)
    {
        printf("===== Function %s(", scope->name);
        TypeNode *param = scope->ref_sym->params;
        if (param != NULL)
        {
            printf("%s", type_str(param->type));
            for (param = param->next; param != NULL; param = param->next)
            {
                printf(",%s", type_str(param->type));
            }
        }
        printf(") Symbol Table =====\n");
        printf("return\t%s\n", type_str(scope->return_type));
    }
    else
    {
        printf("===== Global Symbol Table =====\n");
    }

    int i = 0;
    for (Symbol *s = scope->symbols; s != NULL; s = s->next)
    {
        printf("%s\t", s->name);
        if (s->is_func)
        {
            TypeNode *param = s->params;
            printf("(");
            if (param != NULL)
            {
                printf("%s", type_str(param->type));
                for (param = param->next; param != NULL; param = param->next)
                {
                    printf(",%s", type_str(param->type));
                }
            }
            printf(")");
        }
        printf("\t%s", type_str(s->type));
        if (i < scope->num_params)
            printf("\tparam\n");
        else
            printf("\n");
        i++;
    }
    printf("\n");
}

void print_scopes(Scope *scope)
{
    for (Scope *ptr = scope; ptr != NULL; ptr = ptr->next)
    {
        print_scope(ptr);
    }
}
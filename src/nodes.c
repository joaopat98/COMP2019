#include "nodes.h"

Node *new_node(int type, tokeninfo token)
{
    Node *n = (Node *)malloc(sizeof(Node));
    n->children = NULL;
    n->next = NULL;
    n->type = (node_type)type;
    n->val = token.val;
    n->line = token.line;
    n->col = token.col;
    return n;
}

Node *new_empty_node(int type)
{
    Node *n = (Node *)malloc(sizeof(Node));
    n->children = NULL;
    n->next = NULL;
    n->type = (node_type)type;
    n->val = NULL;
    n->line = -1;
    n->col = -1;
    return n;
}

void append_child(Node *parent, Node *child)
{
    Node *ptr = parent->children;
    if (ptr == NULL)
        parent->children = child;
    else
    {
        while (ptr->next != NULL)
            ptr = ptr->next;
        ptr->next = child;
    }
}
void unshift_child(Node *parent, Node *child)
{
    child->next = parent->children;
    parent->children = child;
}

void add_neighbour(Node *child, Node *new_child)
{
    Node *ptr = child;
    while (ptr->next != NULL)
        ptr = ptr->next;
    ptr->next = new_child;
}

int count(Node *n)
{
    int i = 0;
    for (Node *ptr = n; ptr != NULL; ptr = ptr->next)
    {
        i++;
    }
    return i;
}

void print_tree(Node *n, int level, bool to_print)
{
    if (n != NULL)
    {
        if (to_print)
        {
            for (int i = 0; i < level; i++)
                printf("..");
            switch (n->type)
            {
            case Program:
                printf("Program");
                break;
            case VarDecl:
                printf("VarDecl");
                break;
            case FuncDecl:
                printf("FuncDecl");
                break;
            case FuncHeader:
                printf("FuncHeader");
                break;
            case FuncParams:
                printf("FuncParams");
                break;
            case FuncBody:
                printf("FuncBody");
                break;
            case ParamDecl:
                printf("ParamDecl");
                break;
            case Block:
                printf("Block");
                break;
            case If:
                printf("If");
                break;
            case For:
                printf("For");
                break;
            case Return:
                printf("Return");
                break;
            case Call:
                printf("Call");
                break;
            case Print:
                printf("Print");
                break;
            case ParseArgs:
                printf("ParseArgs");
                break;
            case Or:
                printf("Or");
                break;
            case And:
                printf("And");
                break;
            case Eq:
                printf("Eq");
                break;
            case Ne:
                printf("Ne");
                break;
            case Lt:
                printf("Lt");
                break;
            case Gt:
                printf("Gt");
                break;
            case Le:
                printf("Le");
                break;
            case Ge:
                printf("Ge");
                break;
            case Add:
                printf("Add");
                break;
            case Sub:
                printf("Sub");
                break;
            case Mul:
                printf("Mul");
                break;
            case Div:
                printf("Div");
                break;
            case Mod:
                printf("Mod");
                break;
            case Not:
                printf("Not");
                break;
            case Minus:
                printf("Minus");
                break;
            case Plus:
                printf("Plus");
                break;
            case Assign:
                printf("Assign");
                break;
            case Int:
                printf("Int");
                break;
            case Float32:
                printf("Float32");
                break;
            case Bool:
                printf("Bool");
                break;
            case String:
                printf("String");
                break;
            case IntLit:
                printf("IntLit(%s)", n->val);
                break;
            case RealLit:
                printf("RealLit(%s)", n->val);
                break;
            case Id:
                printf("Id(%s)", n->val);
                break;
            case StrLit:
                printf("StrLit(\"%s\")", n->val);
                break;
            }
            printf(" - l. %d, c. %d\n", n->line, n->col);
        }
        print_tree(n->children, level + 1, to_print);
        print_tree(n->next, level, to_print);
        free(n->val);
        free(n);
    }
}
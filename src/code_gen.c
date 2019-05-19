#include "code_gen.h"

int temp_counter;
int label_counter;

const char *init = "@.int_format = private unnamed_addr constant [4 x i8] c\"%d\\0A\\00\"\n"
                   "@.float_format = private unnamed_addr constant [7 x i8] c\"%.08f\\0A\\00\"\n"
                   "@.bool_true = private unnamed_addr constant [6 x i8] c\"true\\0A\\00\"\n"
                   "@.bool_false = private unnamed_addr constant [7 x i8] c\"false\\0A\\00\"\n"
                   "@.null_str = external global i8\n"
                   "\n"
                   "declare i32 @printf(i8* , ...)\n"
                   "\n"
                   "define i32 @print_int(i32 %num) {\n"
                   "    %1 = getelementptr [4 x i8], [4 x i8]* @.int_format, i64 0, i64 0\n"
                   "    call i32 (i8*, ...) @printf(i8* %1, i32 %num)\n"
                   "    ret i32 0\n"
                   "}\n"
                   "\n"
                   "define i32 @print_float(double %num) {\n"
                   "    %1 = getelementptr [7 x i8], [7 x i8]* @.float_format, i64 0, i64 0\n"
                   "    call i32 (i8*, ...) @printf(i8* %1, double %num)\n"
                   "    ret i32 0\n"
                   "}\n"
                   "\n"
                   "define i32 @print_string(i8* %str) {\n"
                   "    call i32 (i8*, ...) @printf(i8* %str)\n"
                   "    ret i32 0\n"
                   "}\n"
                   "\n"
                   "define i32 @print_bool(i1 %num) {\n"
                   "    br i1 %num, label %true, label %end\n"
                   "\n"
                   "    true:\n"
                   "    %1 = getelementptr [6 x i8], [6 x i8]* @.bool_true, i64 0, i64 0\n"
                   "    call i32 (i8*, ...) @printf(i8* %1)\n"
                   "    br label %end\n"
                   "\n"
                   "    false:\n"
                   "    %3 = getelementptr [7 x i8], [7 x i8]* @.bool_false, i64 0, i64 0\n"
                   "    call i32 (i8*, ...) @printf(i8* %3)\n"
                   "    br label %end\n"
                   "\n"
                   "    end:\n"
                   "    ret i32 0\n"
                   "}\n"
                   "\n"
                   "declare i32 @atoi(i8*)\n";

const char *ll_type(sym_type type)
{
    switch (type)
    {
    case integer_type:
        return "i32";
    case float32_type:
        return "double";
    case bool_type:
        return "i1";
    case string_type:
        return "i8*";
    default:
        return "i32";
    }
}

int expr_code(Node *n, Scope *scope)
{
    int first, second;
    int result_var;
    char params[1000];
    if (n->children != NULL && n->type != Call)
    {
        first = expr_code(n->children, scope);
        if (n->children->next != NULL)
            second = expr_code(n->children->next, scope);
        result_var = temp_counter++;
        printf("%%.%d = ", result_var);
    }
    switch (n->type)
    {
    case Or:
        printf("and i1 %%.%d, %%.%d\n", first, second);
        break;
    case And:
        printf("or i1 %%.%d, %%.%d\n", first, second);
        break;
    case Lt:
    case Gt:
    case Le:
    case Ge:
    case Eq:
    case Ne:
        if (n->children->symbol_type == float32_type)
        {
            printf("fcmp ");
            switch (n->type)
            {
            case Lt:
                printf("olt ");
                break;
            case Gt:
                printf("ogt ");
                break;
            case Le:
                printf("ole ");
                break;
            case Ge:
                printf("oge ");
                break;
            case Eq:
                printf("oeq ");
                break;
            case Ne:
                printf("one ");
                break;
            default:
                break;
            }
        }
        else
        {
            printf("icmp ");
            switch (n->type)
            {
            case Lt:
                printf("slt ");
                break;
            case Gt:
                printf("sgt ");
                break;
            case Le:
                printf("sle ");
                break;
            case Ge:
                printf("sge ");
                break;
            case Eq:
                printf("eq ");
                break;
            case Ne:
                printf("ne ");
                break;
            default:
                break;
            }
        }

        printf("%s %%.%d, %%.%d\n", ll_type(n->children->symbol_type), first, second);

        break;
    case Add:
    case Sub:
    case Mul:
    case Div:
        if (n->symbol_type == float32_type)
        {
            printf("f");
        }
        else if (n->type == Div)
        {
            printf("s");
        }

        switch (n->type)
        {
        case Add:
            printf("add ");
            break;
        case Sub:
            printf("sub ");
            break;
        case Mul:
            printf("mul ");
            break;
        case Div:
            printf("div ");
            break;
        default:
            break;
        }

        printf("%s %%.%d, %%.%d\n", ll_type(n->symbol_type), first, second);

        break;
    case Mod:
        printf("srem i32 %%.%d, %%.%d\n", first, second);
        break;
    case Not:
        printf("icmp eq i1 0, %%.%d", first);
        break;
    case Minus:
        if (n->symbol_type == float32_type)
        {
            printf("fmul %s -1.0, %%.%d\n", ll_type(n->symbol_type), first);
        }
        else
        {
            printf("smul %s -1, %%.%d\n", ll_type(n->symbol_type), first);
        }
        break;
    case Plus:
        if (n->symbol_type == float32_type)
        {
            printf("fadd %s 0.0, %%.%d\n", ll_type(n->symbol_type), first);
        }
        else
        {
            printf("add %s 0, %%.%d\n", ll_type(n->symbol_type), first);
        }
        break;
    case IntLit:
        result_var = temp_counter++;
        printf("%%.%d = add i32 0, %s\n", result_var, n->val);
        break;
    case RealLit:
    {
        char f_buf[1000];
        f_buf[0] = 0;

        result_var = temp_counter++;
        if (n->val[0] == '.')
            sprintf(f_buf, "0");
        sprintf(f_buf + strlen(f_buf), "%s", n->val);

        printf("%%.%d = fadd double %s, 0.0\n", result_var, f_buf);
    }
    break;
    case Id:
    {
        result_var = temp_counter++;
        if (is_local(scope, n))
        {
            printf("%%.%d = load %s, %s* %%%s\n", result_var, ll_type(n->symbol_type), ll_type(n->symbol_type), n->val);
        }
        else
        {
            printf("%%.%d = load %s, %s* @%s\n", result_var, ll_type(n->symbol_type), ll_type(n->symbol_type), n->val);
        }
    }
    break;
    case Call:
        params[0] = 0;
        if (n->children->next != NULL)
        {
            Node *call_param = n->children->next;
            sprintf(params, "%s %%.%d", ll_type(call_param->symbol_type), expr_code(call_param, scope));
            for (call_param = call_param->next; call_param != NULL; call_param = call_param->next)
            {
                sprintf(params + strlen(params), ", %s %%.%d", ll_type(call_param->symbol_type), expr_code(call_param, scope));
            }
        }
        result_var = temp_counter++;
        printf("%%.%d = call %s @%s(%s)\n", result_var, ll_type(n->symbol_type), n->children->val, params);
        break;
    default:
        break;
    }
    return result_var;
}

void stmt_code(Node *n, Scope *scope)
{
    Node *temp;
    switch (n->type)
    {
    case Assign:
        temp = n->children->next;
        if (is_local(scope, n->children))
            printf("store %s %%.%d, %s* %%%s\n", ll_type(temp->symbol_type), expr_code(temp, scope), ll_type(temp->symbol_type), n->children->val);
        else
            printf("store %s %%.%d, %s* @%s\n", ll_type(temp->symbol_type), expr_code(temp, scope), ll_type(temp->symbol_type), n->children->val);
        break;
    case For:

        if (count(n->children) > 1)
        {
            temp = n->children;
            int cond_l = label_counter++;
            int start_l = label_counter++;
            int end_l = label_counter++;

            printf("br label %%l_%d\n\n", cond_l);
            printf("l_%d:\n", cond_l);
            printf("br i1 %%.%d, label %%l_%d, label %%l_%d\n\n", expr_code(temp, scope), start_l, end_l);
            printf("l_%d:", start_l);

            for (Node *ptr = temp->next->children; ptr != NULL; ptr = ptr->next)
            {
                stmt_code(ptr, scope);
            }

            printf("br label %%l_%d\n\n", cond_l);
            printf("l_%d:", end_l);
        }
        else
        {
            temp = n->children;
            int start_l = label_counter++;
            int end_l = label_counter++;
            printf("l_%d:", start_l);

            for (Node *ptr = temp->next->children; ptr != NULL; ptr = ptr->next)
            {
                stmt_code(ptr, scope);
            }

            printf("br label %%l_%d\n\n", start_l);
            printf("l_%d:", end_l);
        }
        break;
    case If:
        temp = n->children;

        if (temp->next->next != NULL)
        {
            int true_l = label_counter++;
            int false_l = label_counter++;
            int end_l = label_counter++;

            printf("br i1 %%.%d, label %%l_%d, label %%l_%d\n\n", expr_code(temp, scope), true_l, false_l);
            printf("l_%d:\n", true_l);

            for (Node *ptr = temp->next->children; ptr != NULL; ptr = ptr->next)
            {
                stmt_code(ptr, scope);
            }

            printf("br label %%l_%d\n\n", end_l);
            printf("l_%d:\n", false_l);

            for (Node *ptr = temp->next->next->children; ptr != NULL; ptr = ptr->next)
            {
                stmt_code(ptr, scope);
            }

            printf("br label %%l_%d\n\n", end_l);
            printf("l_%d:\n", end_l);
        }
        else
        {
            int true_l = label_counter++;
            int end_l = label_counter++;

            printf("br i1 %%.%d, label %%l_%d, label %%l_%d\n\n", expr_code(temp, scope), true_l, end_l);
            printf("l_%d:\n", true_l);

            for (Node *ptr = temp->next->children; ptr != NULL; ptr = ptr->next)
            {
                stmt_code(ptr, scope);
            }

            printf("br label %%l_%d\n\n", end_l);
            printf("l_%d:\n", end_l);
        }
        break;
    case Return:
        if (n->children != NULL)
        {
            printf("ret %s %%.%d\n", ll_type(n->children->symbol_type), expr_code(n->children, scope));
        }
        else
        {
            printf("ret\n");
        }
        break;
    case Print:
        switch (n->children->symbol_type)
        {
        case integer_type:
            printf("call i32 @print_int(i32 %%.%d)\n", expr_code(n->children, scope));
            break;
        case float32_type:
            printf("call i32 @print_float(double %%.%d)\n", expr_code(n->children, scope));
            break;
        case bool_type:
            printf("call i32 @print_bool(i1 %%.%d)\n", expr_code(n->children, scope));
            break;
        case string_type:
            printf("call i32 @print_string(i8* %%.%d)\n", expr_code(n->children, scope));
            break;
        default:
            break;
        }
        break;
    case ParseArgs:
    {
        int index_var = expr_code(n->children->next, scope);
        int arr_ptr = temp_counter++;
        int str_ptr = temp_counter++;
        int str = temp_counter++;
        int result_var = temp_counter++;
        printf("%%.%d = load i8**, i8*** %%osargs\n", arr_ptr);
        printf("%%.%d = getelementptr i8*, i8** %%.%d, i32 %%.%d\n", str_ptr, arr_ptr, index_var);
        printf("%%.%d = load i8*, i8** %%.%d", str, str_ptr);
        printf("%%.%d = call i32 @atoi(i8* %%.%d)\n", result_var, str);
        printf("store i32 %%.%d, i32* %%%s\n", result_var, n->children->val);
    }
    break;
    case Block:
        for (Node *ptr = n->children; ptr != NULL; ptr = ptr->next)
        {
            stmt_code(ptr, scope);
        }
        break;
    case Call:
        expr_code(n, scope);
        break;
    default:
        break;
    }
}

void code_gen(Scope *global)
{
    printf("%s", init);

    for (Symbol *ptr = global->symbols; ptr != NULL; ptr = ptr->next)
    {
        if (!ptr->is_func)
        {
            printf("@%s = external global %s\n", ptr->name, ll_type(ptr->type));
        }
    }
    for (Scope *func = global->next; func != NULL; func = func->next)
    {
        int i = 0;
        if (!strcmp(func->name, "main"))
        {
            i = 2;
            printf("define i32 @main(i32, i8**) {\n");

            printf("%%osargs = alloca i8**\n");

            printf("store i8** %%1, i8*** %%osargs\n");
            for (Symbol *sym = func->symbols; sym != NULL; sym = sym->next)
            {
                printf("%%%s = alloca %s\n", sym->name, ll_type(sym->type));
            }
        }
        else
        {
            printf("define %s @%s(", ll_type(func->return_type), func->name);
            if (func->num_params > 0)
            {
                Symbol *param = func->symbols;
                printf("%s", ll_type(param->type));
                int i = 1;
                for (param = param->next; i++ < func->num_params; param = param->next)
                {
                    printf(", %s", ll_type(param->type));
                }
            }
            printf(") {\n");
            for (Symbol *sym = func->symbols; sym != NULL; sym = sym->next)
            {
                printf("%%%s = alloca %s\n", sym->name, ll_type(sym->type));
                if (i < func->num_params)
                {
                    printf("store %s %%%d, %s* %%%s\n", ll_type(sym->type), i++, ll_type(sym->type), sym->name);
                }
            }
        }
        temp_counter = i + 1;
        for (Node *n = func->body->children; n != NULL; n = n->next)
        {
            stmt_code(n, func);
        }

        if (func->return_type == float32_type)
            printf("ret %s 0.0\n", ll_type(func->return_type));
        else if (func->return_type == string_type)
            printf("ret %s @.null_str\n", ll_type(func->return_type));
        else
            printf("ret %s 0\n", ll_type(func->return_type));
        printf("}\n");
    }
}
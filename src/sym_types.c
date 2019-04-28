#include "sym_types.h"

const char *type_str(sym_type type)
{
    switch (type)
    {
    case integer_type:
        return "int";
    case float32_type:
        return "float32";
    case bool_type:
        return "bool";
    case string_type:
        return "string";
    case undef:
        return "undef";
    default:
        return "no type";
    }
}
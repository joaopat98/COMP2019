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
    case none:
        return "none";
    case undef:
        return "undef";
    default:
        return "no type";
    }
}

bool is_numeric(sym_type type)
{
    return type == float32_type || type == integer_type;
}
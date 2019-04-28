#ifndef SYM_TYPES_H
#define SYM_TYPES_H 1

typedef enum
{
    integer_type,
    float32_type,
    bool_type,
    string_type,
    undef,
    no_type
} sym_type;

const char *type_str(sym_type type);

#endif
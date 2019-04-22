#ifndef TOKEN_H
#define TOKEN_H 0
typedef struct
{
    int line;
    int col;
    char *val;
} tokeninfo;
#endif
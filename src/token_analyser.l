letter      [a-z]|[A-Z]
digit       [0-9]
id          {letter}({letter}|{digit}|"_")*
int1        {digit}+
int2        ("0x"|"0X")(digit|[a-f]|[A-F])+
int_lit     {int1}|{int2}
decimal     {int1}"."{int1}
exponent    (e|E)("+"|"-")?({decimal}|{int1})
real_lit    ({decimal}{exponent}?)|({int1}{exponent})
escape_char \\[fnrt\\\"]
str_char    [^"\\]
str_lit     \"({escape_char}|{str_char})*\"
semicolon   ";"|";\n"
blank_id    "_"
package     "package"
return      "return"
and         "&&"
assign      "="
star        "*"
comma       ","
div         "/"
eq          "=="
ge          ">="
gt          ">"
l_brace      "{"
le          "<="
l_par       "("
lsq         "["
lt          "<"
minus       "-"
mod         "%"
ne          "!="
not         "!"
or          "||"
plus        "+"
r_brace     "}"
r_par       ")"
rsq         "]"
else        "else"
for         "for"
if          "if"
var         "var"
int         "int"
float32     "float32"
bool        "bool"
string      "string"
print       "fmt.Println"
parse_int   "strconv.Atoi"
func        "func"
cmdargs     "os.Args"
%%
{package}   {
    printf("PACKAGE\n");
}
{func}   {
    printf("FUNC\n");
}
{l_par}   {
    printf("LPAR\n");
}
{r_par}   {
    printf("RPAR\n");
}
{int}   {
    printf("INT\n");
}
{l_brace}   {
    printf("LBRACE\n");
}
{r_brace}   {
    printf("RBRACE\n");
}
{if}   {
    printf("IF\n");
}
{eq}   {
    printf("EQ\n");
}
{return}   {
    printf("RETURN\n");
}
{semicolon}   {
    printf("SEMICOLON\n");
}
{star}   {
    printf("STAR\n");
}
{minus} {
    printf("MINUS\n");
}
{blank_id}  {
    printf("BLANKID\n");
}
{assign}  {
    printf("ASSIGN\n");
}
{lsq}  {
    printf("LSQ\n");
}
{rsq}  {
    printf("RSQ\n");
}
{var}   {
    printf("VAR\n");
}
{comma}   {
    printf("COMMA\n");
}
{parse_int}   {
    printf("PARSEINT\n");
}
{cmdargs}   {
    printf("CMDARGS\n");
}
{print}   {
    printf("PRINT\n");
}
{str_lit}   {
    printf("STRLIT(%s)\n", yytext);
}
{int_lit}   {
    printf("INTLIT(%s)\n", yytext);
}
{real_lit}   {
    printf("REALLIT(%s)\n", yytext);
}
{id}    {
    printf("ID(%s)\n", yytext);
}

.|\n   {;}
%%
int main()
{
yylex();
return 0;
}

int yywrap()
{
return 1;
}
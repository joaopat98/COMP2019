%{
    #include <string.h>
    #include <stdbool.h>

    typedef enum {
        OTHER,
        ID,
        INTLIT,
        REALLIT,
        STRLIT,
        RETURN,
        RPAR,
        RSQ,
        RBRACE
    } token;
    bool print = false;
    int line = 1, col = 1;
    void ucol(){
        col += yyleng;
    }
    void uline(){
        line++;
        col = 1;
    }
    bool error = false;
    char buf[512] = "";
    int pos, lpos;
    token last_token = OTHER;
    void rlast(){
        last_token = OTHER;
    }
    void slast(token tok){
        last_token = tok;
    }
    void abuf(){
        strcat(buf, yytext);
    }
    void rbuf(){
        memset(buf,0,sizeof(buf));
    }
%}
%X str seq comment multi_comment
whitespace  " "|\t|\r
letter      [a-z]|[A-Z]|_
digit       [0-9]
id          {letter}({letter}|{digit})*
int2        ("0x"|"0X")({digit}|[a-f]|[A-F])+
int1        {digit}+
int_lit     {int2}|{int1}
decimal     ({int1}"."{int1}?)|("."{int1})
exponent    (e|E)("+"|"-")?({decimal}|{int1})
real_lit    ({decimal}{exponent}?)|({int1}{exponent})
esc_seq     \\
illegal_esc [^fnrt\\\"]
legal_esc   [fnrt\\\"]
str_char    [^\"\\\n\r]
str_delim   \"
semicolon   ";"
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
reserved    "break"|"case"|"chan"|"const"|"continue"|"default"|"defer"|"fallthrough"|"go"|"goto"|"import"|"interface"|"map"|"range"|"select"|"struct"|"switch"|"type"|"++"|"--"
%%

{reserved}  {
    if (print) printf("RESERVED(%s)\n", yytext);
    rlast();
    ucol();
}
{string}   {
    if (print) printf("STRING\n");
    rlast();
    ucol();
}
{bool}   {
    if (print) printf("BOOL\n");
    rlast();
    ucol();
}
{float32}   {
    if (print) printf("FLOAT32\n");
    rlast();
    ucol();
}
{or}   {
    if (print) printf("OR\n");
    rlast();
    ucol();
}
{not}   {
    if (print) printf("NOT\n");
    rlast();
    ucol();
}
{ne}   {
    if (print) printf("NE\n");
    rlast();
    ucol();
}
{mod}   {
    if (print) printf("MOD\n");
    rlast();
    ucol();
}
{le}   {
    if (print) printf("LE\n");
    rlast();
    ucol();
}
{lt}   {
    if (print) printf("LT\n");
    rlast();
    ucol();
}
{ge}   {
    if (print) printf("GE\n");
    rlast();
    ucol();
}
{gt}   {
    if (print) printf("GT\n");
    rlast();
    ucol();
}
{div}   {
    if (print) printf("DIV\n");
    rlast();
    ucol();
}
{and}   {
    if (print) printf("AND\n");
    rlast();
    ucol();
}
{package}   {
    if (print) printf("PACKAGE\n");
    rlast();
    ucol();
}
{func}   {
    if (print) printf("FUNC\n");
    rlast();
    ucol();
}
{else}  {
    if (print) printf("ELSE\n");
    rlast();
    ucol();
}
{l_par}   {
    if (print) printf("LPAR\n");
    rlast();
    ucol();
}
{r_par}   {
    if (print) printf("RPAR\n");
    slast(RPAR);
    ucol();
}
{int}   {
    if (print) printf("INT\n");
    rlast();
    ucol();
}
{l_brace}   {
    if (print) printf("LBRACE\n");
    rlast();
    ucol();
}
{r_brace}   {
    if (print) printf("RBRACE\n");
    slast(RBRACE);
    ucol();
}
{if}   {
    if (print) printf("IF\n");
    rlast();
    ucol();
}
{eq}   {
    if (print) printf("EQ\n");
    rlast();
    ucol();
}
{for}   {
    if (print) printf("FOR\n");
    rlast();
    ucol();
}
{plus}  {
    if (print) printf("PLUS\n");
    rlast();
    ucol();
}
{return}   {
    if (print) printf("RETURN\n");
    slast(RETURN);
    ucol();
}
{semicolon}   {
    if (print) printf("SEMICOLON\n");
    rlast();
    ucol();
}
{star}   {
    if (print) printf("STAR\n");
    rlast();
    ucol();
}
{minus} {
    if (print) printf("MINUS\n");
    rlast();
    ucol();
}
{blank_id}  {
    if (print) printf("BLANKID\n");
    slast(ID);
    ucol();
}
{assign}  {
    if (print) printf("ASSIGN\n");
    rlast();
    ucol();
}
{lsq}  {
    if (print) printf("LSQ\n");
    rlast();
    ucol();
}
{rsq}  {
    if (print) printf("RSQ\n");
    slast(RSQ);
    ucol();
}
{var}   {
    if (print) printf("VAR\n");
    rlast();
    ucol();
}
{comma}   {
    if (print) printf("COMMA\n");
    rlast();
    ucol();
}
{parse_int}   {
    if (print) printf("PARSEINT\n");
    rlast();
    ucol();
}
{cmdargs}   {
    if (print) printf("CMDARGS\n");
    rlast();
    ucol();
}
{print}   {
    if (print) printf("PRINT\n");
    rlast();
    ucol();
}
{str_delim}   {
    pos = col;
    ucol();
    BEGIN str;
}
<str>{esc_seq}  {
    abuf();
    ucol();
    BEGIN seq;
}
<str>{str_char} {
    abuf();
    ucol();
}
<seq>{legal_esc}    {
    abuf();
    ucol();
    BEGIN str;
}
<seq>{illegal_esc}  {
    printf("Line %d, column %d: invalid escape sequence (\\%s)\n", line, col - 1, yytext);
    abuf();
    ucol();
    error = true;
    BEGIN str;
}
<str>{str_delim}    {
    if (!error){
        if (print) printf("STRLIT(\"%s\")\n",buf);
        slast(STRLIT);
    }
    error = false;
    rbuf();
    ucol();
    BEGIN 0;
}
<str>"\n" {
    printf("Line %d, column %d: unterminated string literal\n", line, pos);
    rlast();
    error = false;
    rbuf();
    uline();
    BEGIN 0;
}

<str><<EOF>> {
    printf("Line %d, column %d: unterminated string literal\n", line, pos);
    return 1;
}

{int_lit}   {
    if (print) printf("INTLIT(%s)\n", yytext);
    slast(INTLIT);
    ucol();
}
{real_lit}   {
    if (print) printf("REALLIT(%s)\n", yytext);
    slast(REALLIT);
    ucol();
}
{id}    {
    if (print) printf("ID(%s)\n", yytext);
    slast(ID);
    ucol();
}

"//"  {
    ucol();
    BEGIN comment;
}
"/*"  {
    pos = col;
    lpos = line;
    ucol();
    BEGIN multi_comment;
}
<comment>[^\n]   {
    ucol();
}
<comment>\n {
    if(last_token != OTHER){
        if (print) printf("SEMICOLON\n");
        rlast();
    }
    uline();
    BEGIN 0;
}
<multi_comment><<EOF>>  {
    printf("Line %d, column %d: unterminated comment\n", lpos, pos);
    return 1;
}
<multi_comment>[^\n]    {
    ucol();
}
<multi_comment>\n   {
    uline();
}
<multi_comment>"*/"  {
    ucol();
    BEGIN 0;
}
{whitespace} {
    ucol();
}

<<EOF>> {
    if(last_token != OTHER){
        if (print) printf("SEMICOLON\n");
        rlast();
    }
    uline();
    return 0;
}

.    {
    printf("Line %d, column %d: illegal character (%s)\n", line, col, yytext);
    ucol();
}

\n   {
    if(last_token != OTHER){
        if (print) printf("SEMICOLON\n");
        rlast();
    }
    uline();
}
%%
int main(int argc, char **argv)
{
    if(argc == 2 && strcmp(argv[1],"-l")==0)
        print = true;
    else 
        print = false;
yylex();
return 0;
}

int yywrap()
{
return 1;
}

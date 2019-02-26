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

    int line = 1, col = 1;
    void ucol(){
        col += yyleng;
    }
    void uline(){
        line++;
        col = 1;
    }
    bool error = false;
    char buf[1000] = "";
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
        buf[0] = 0;
    }
%}
%X str seq comment multi_comment
letter      [a-z]|[A-Z]
digit       [0-9]
id          {letter}({letter}|{digit}|"_")*
int1        {digit}+
int2        ("0x"|"0X")(digit|[a-f]|[A-F])+
int_lit     {int1}|{int2}
decimal     ({int1}"."{int1}?)|("."{int1})
exponent    (e|E)("+"|"-")?({decimal}|{int1})
real_lit    ({decimal}{exponent}?)|({int1}{exponent})
esc_seq     \\
illegal_esc [^fnrt\\\"]
legal_esc   [fnrt\\\"]
str_char    [^"\\\n]
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
%%
{package}   {
    printf("PACKAGE\n");
    rlast();
    ucol();
}
{func}   {
    printf("FUNC\n");
    rlast();
    ucol();
}
{l_par}   {
    printf("LPAR\n");
    rlast();
    ucol();
}
{r_par}   {
    printf("RPAR\n");
    slast(RPAR);
    ucol();
}
{int}   {
    printf("INT\n");
    rlast();
    ucol();
}
{l_brace}   {
    printf("LBRACE\n");
    rlast();
    ucol();
}
{r_brace}   {
    printf("RBRACE\n");
    slast(RBRACE);
    ucol();
}
{if}   {
    printf("IF\n");
    rlast();
    ucol();
}
{eq}   {
    printf("EQ\n");
    rlast();
    ucol();
}
{return}   {
    printf("RETURN\n");
    slast(RETURN);
    ucol();
}
{semicolon}   {
    printf("SEMICOLON\n");
    rlast();
    ucol();
}
{star}   {
    printf("STAR\n");
    rlast();
    ucol();
}
{minus} {
    printf("MINUS\n");
    rlast();
    ucol();
}
{blank_id}  {
    printf("BLANKID\n");
    rlast();
    ucol();
}
{assign}  {
    printf("ASSIGN\n");
    rlast();
    ucol();
}
{lsq}  {
    printf("LSQ\n");
    rlast();
    ucol();
}
{rsq}  {
    printf("RSQ\n");
    slast(RSQ);
    ucol();
}
{var}   {
    printf("VAR\n");
    rlast();
    ucol();
}
{comma}   {
    printf("COMMA\n");
    rlast();
    ucol();
}
{parse_int}   {
    printf("PARSEINT\n");
    rlast();
    ucol();
}
{cmdargs}   {
    printf("CMDARGS\n");
    rlast();
    ucol();
}
{print}   {
    printf("PRINT\n");
    rlast();
    ucol();
}
{str_delim}   {
    pos = col;
    ucol();
    BEGIN str;
}
<str>{str_char} {
    abuf();
    ucol();
}
<str>{esc_seq}  {
    abuf();
    ucol();
    BEGIN seq;
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
        printf("STRLIT(\"%s\")\n",buf);
        slast(STRLIT);
    }
    error = false;
    rbuf();
    ucol();
    BEGIN 0;
}
<str>"\n" {
    printf("Line %d, column %d: unterminated string literal\n", line, pos);
    rbuf();
    uline();
    BEGIN 0;
}


{int_lit}   {
    printf("INTLIT(%s)\n", yytext);
    slast(INTLIT);
    ucol();
}
{real_lit}   {
    printf("REALLIT(%s)\n", yytext);
    slast(REALLIT);
    ucol();
}
{id}    {
    printf("ID(%s)\n", yytext);
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


.    {
    ucol();
}
\n   {
    if(last_token != OTHER){
        printf("SEMICOLON\n");
        rlast();
    }
    uline();
}
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
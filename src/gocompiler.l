/*Guilherme Tavares - 2016228357 */
/*Joao Patricio - 2016228013     */

%{
    #include "nodes.h"
    #include "token.h"
    #include "y.tab.h"
    #include <string.h>
    #include <stdbool.h>

    typedef enum {
        Other_tok,
        Id_tok,
        Intlit_tok,
        Reallit_tok,
        Strlit_tok,
        Return_tok,
        Rpar_tok,
        Rsq_tok,
        Rbrace_tok
    } token;
    bool print = false;
    bool is_string = false;
    int line = 1, col = 1;
    int prev_col;
    void ucol(){
        col += yyleng;
    }
    void uline(){
        line++;
        prev_col = col;
        col = 1;
    }
    bool error = false;
    char buf[512];
    int pos, lpos;
    token last_token = Other_tok;
    void rlast(){
        last_token = Other_tok;
        is_string = false;
    }
    void slast(token tok){
        last_token = tok;
        is_string = tok == Strlit_tok ? true : false;
    }
    void abuf(){
        strcat(buf, yytext);
    }
    void rbuf(){
        memset(buf,0,sizeof(buf));
    }

    void save_token(char *val){
        yylval.token.line = line;
        yylval.token.col = col;
        yylval.token.val = (char *)strdup(val);
    }

    void save_empty_token(){
        yylval.token.line = line;
        yylval.token.col = col;
        yylval.token.val = NULL;
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
    save_empty_token();
    ucol();
    if (!print) return RESERVED;
}
{string}   {
    if (print) printf("STRING\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return STRING;
}
{bool}   {
    if (print) printf("BOOL\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return BOOL;
}
{float32}   {
    if (print) printf("FLOAT32\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return FLOAT32;
}
{or}   {
    if (print) printf("OR\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return OR;
}
{not}   {
    if (print) printf("NOT\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return NOT;
}
{ne}   {
    if (print) printf("NE\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return NE;
}
{mod}   {
    if (print) printf("MOD\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return MOD;
}
{le}   {
    if (print) printf("LE\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return LE;
}
{lt}   {
    if (print) printf("LT\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return LT;
}
{ge}   {
    if (print) printf("GE\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return GE;
}
{gt}   {
    if (print) printf("GT\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return GT;
}
{div}   {
    if (print) printf("DIV\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return DIV;
}
{and}   {
    if (print) printf("AND\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return AND;
}
{package}   {
    if (print) printf("PACKAGE\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return PACKAGE;
}
{func}   {
    if (print) printf("FUNC\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return FUNC;
}
{else}  {
    if (print) printf("ELSE\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return ELSE;
}
{l_par}   {
    if (print) printf("LPAR\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return LPAR;
}
{r_par}   {
    if (print) printf("RPAR\n");
    slast(Rpar_tok);
    save_empty_token();
    ucol();
    if (!print) return RPAR;
}
{int}   {
    if (print) printf("INT\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return INT;
}
{l_brace}   {
    if (print) printf("LBRACE\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return LBRACE;
}
{r_brace}   {
    if (print) printf("RBRACE\n");
    slast(Rbrace_tok);
    save_empty_token();
    ucol();
    if (!print) return RBRACE;
}
{if}   {
    if (print) printf("IF\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return IF;
}
{eq}   {
    if (print) printf("EQ\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return EQ;
}
{for}   {
    if (print) printf("FOR\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return FOR;
}
{plus}  {
    if (print) printf("PLUS\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return PLUS;
}
{return}   {
    if (print) printf("RETURN\n");
    slast(Return_tok);
    save_empty_token();
    ucol();
    if (!print) return RETURN;
}
{semicolon}   {
    if (print) printf("SEMICOLON\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return SEMICOLON;
}
{star}   {
    if (print) printf("STAR\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return STAR;
}
{minus} {
    if (print) printf("MINUS\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return MINUS;
}
{blank_id}  {
    if (print) printf("BLANKID\n");
    slast(Id_tok);
    save_empty_token();
    ucol();
    if (!print) return BLANKID;
}
{assign}  {
    if (print) printf("ASSIGN\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return ASSIGN;
}
{lsq}  {
    if (print) printf("LSQ\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return LSQ;
}
{rsq}  {
    if (print) printf("RSQ\n");
    slast(Rsq_tok);
    save_empty_token();
    ucol();
    if (!print) return RSQ;
}
{var}   {
    if (print) printf("VAR\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return VAR;
}
{comma}   {
    if (print) printf("COMMA\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return COMMA;
}
{parse_int}   {
    if (print) printf("PARSEINT\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return PARSEINT;
}
{cmdargs}   {
    if (print) printf("CMDARGS\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return CMDARGS;
}
{print}   {
    if (print) printf("PRINT\n");
    rlast();
    save_empty_token();
    ucol();
    if (!print) return PRINT;
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

        if (print) {
            printf("STRLIT(\"%s\")\n",buf);
        }
        slast(Strlit_tok);
        save_token(buf);
    }
    rbuf();
    ucol();
    BEGIN 0;
    if (!print && !error) {
        error = false;
        return STRLIT;
    }
    error = false;
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
    slast(Intlit_tok);
    save_token(yytext);
    ucol();
    if (!print) return INTLIT;
}
{real_lit}   {
    if (print) printf("REALLIT(%s)\n", yytext);
    slast(Reallit_tok);
    save_token(yytext);
    ucol();
    if (!print) return REALLIT;
}
{id}    {
    if (print) printf("ID(%s)\n", yytext);
    slast(Id_tok);
    save_token(yytext);
    ucol();
    if (!print) return ID;
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
    if(last_token != Other_tok){
        if (print) printf("SEMICOLON\n");
        rlast();
        save_empty_token();
        if (!print) return SEMICOLON;
    }
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
    line--;
    col = prev_col;
    if(last_token != Other_tok){
        if (print) printf("SEMICOLON\n");
        rlast();
        save_empty_token();
        if (!print) return SEMICOLON;
    }
    return 0;
}

.    {
    printf("Line %d, column %d: illegal character (%s)\n", line, col, yytext);
    ucol();
}

\n   {
    uline();
    if(last_token != Other_tok){
        if (print) printf("SEMICOLON\n");
        rlast();
        save_empty_token();
        if (!print) return SEMICOLON;
    }
}
%%

int yywrap() {
    return 1;
}

int lex_init(int argc, char **argv)
{
    if(argc == 2 && strcmp(argv[1],"-l")==0)
        print = true;
    else 
        print = false;
    return 0;
}



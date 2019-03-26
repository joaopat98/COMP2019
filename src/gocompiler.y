%{
    #include <stdio.h>
    #include <string.h>
    int yylex(void);
    void yyerror (const char *s);
    int line, col, yyleng;
    char *yytext;
%}

/*
%define parse.error verbose
*/

%union {
    int intval;
    double realval;
    char* strval;
}

%token ID
%token INTLIT
%token REALLIT
%token STRLIT
%token SEMICOLON
%token BLANKID
%token PACKAGE
%token RETURN
%token AND OR
%token ASSIGN
%token COMMA
%token EQ NE GE GT LE LT
%token LPAR RPAR LBRACE RBRACE LSQ RSQ
%token MINUS PLUS STAR DIV MOD
%token NOT
%token IF ELSE FOR
%token VAR
%token INT
%token FLOAT32
%token BOOL
%token STRING
%token PRINT
%token PARSEINT
%token FUNC
%token CMDARGS
%token RESERVED
%token IMPORTANT

%right ASSIGN
%left AND OR
%left GE GT LE LT EQ NE
%left PLUS MINUS
%left STAR DIV MOD
%left LPAR
%right IMPORTANT

%%

Program: PACKAGE ID SEMICOLON Declarations;
Declarations: VarDeclaration SEMICOLON Declarations
| FuncDeclaration SEMICOLON Declarations
| %empty;
VarDeclaration: VAR VarSpec;
| VAR LPAR VarSpec SEMICOLON RPAR;
MultiId: COMMA ID MultiId
| %empty;
VarSpec: ID MultiId Type;
Type: INT | FLOAT32 | BOOL | STRING;
FuncDeclaration: FUNC ID LPAR Parameters RPAR Type FuncBody
| FUNC ID LPAR RPAR Type FuncBody
| FUNC ID LPAR Parameters RPAR FuncBody
| FUNC ID LPAR RPAR FuncBody;
Parameters: ID Type MultiParam
MultiParam: COMMA ID Type MultiParam
| %empty;
FuncBody: LBRACE VarsAndStatements RBRACE;
VarsAndStatements: VarsAndStatements SEMICOLON
| VarsAndStatements VarDeclaration SEMICOLON
| VarsAndStatements Statement SEMICOLON
| %empty;
Statement: ID ASSIGN Expr
| LBRACE MultiStatement RBRACE
| IF Expr LBRACE MultiStatement RBRACE ELSE LBRACE MultiStatement RBRACE
| IF Expr LBRACE MultiStatement RBRACE
| FOR Expr LBRACE MultiStatement RBRACE
| FOR LBRACE MultiStatement RBRACE
| RETURN Expr
| RETURN
| FuncInvocation
| ParseArgs
| PRINT LPAR Expr RPAR
| PRINT LPAR STRLIT RPAR
| error;
MultiStatement: Statement SEMICOLON MultiStatement
| %empty;
ParseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR
| ID COMMA BLANKID ASSIGN PARSEINT LPAR error RPAR;
FuncInvocation: ID LPAR Expr ExtraFuncArgs RPAR
| ID LPAR RPAR
| ID LPAR error RPAR;
ExtraFuncArgs: COMMA Expr ExtraFuncArgs
| %empty;
Expr: Expr OR Expr
| Expr AND Expr
| Expr LT Expr
| Expr GT Expr
| Expr EQ Expr
| Expr NE Expr
| Expr LE Expr
| Expr GE Expr
| Expr PLUS Expr
| Expr MINUS Expr
| Expr STAR Expr
| Expr DIV Expr
| Expr MOD Expr
| NOT Expr %prec IMPORTANT
| MINUS Expr %prec IMPORTANT
| PLUS Expr %prec IMPORTANT
| INTLIT | REALLIT | ID | FuncInvocation | LPAR Expr RPAR
| LPAR error RPAR;

%%

void  yyerror (const char *s) {
    printf ("Line %d, column %d: %s: %s\n", line, col - yyleng, s, yytext );
}

int lex_init(int argc, char **argv);

int main(int argc, char **argv) {
    lex_init(argc, argv);
    if(argc >= 2 && strcmp(argv[1],"-l")==0) {
        yylex();
        return 0;
    }
    yyparse();
    return 0;
}
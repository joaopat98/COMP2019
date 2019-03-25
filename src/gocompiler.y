%{
    #include <stdio.h>
    int yylex(void);
    void yyerror (const char *s);
%}

%define parse.error verbose


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

%%

Program: PACKAGE ID SEMICOLON Declarations;
Declarations: VarDeclaration SEMICOLON Declarations
| FuncDeclaration SEMICOLON Declarations
| %empty;
VarDeclaration: VAR VarSpec;
VarDeclaration: VAR LPAR VarSpec SEMICOLON RPAR;
MultiId: COMMA ID MultiId
| %empty;
VarSpec: ID MultiId Type;
Type: INT | FLOAT32 | BOOL | STRING;
FuncDeclaration: FUNC ID LPAR Parameters RPAR Type FuncBody
| FUNC ID LPAR RPAR Type FuncBody
| FUNC ID LPAR Parameters RPAR FuncBody
| FUNC ID LPAR RPAR FuncBody;
Parameters: ID Type COMMA ID Type
| ID Type;
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
| PRINT LPAR STRLIT RPAR;
MultiStatement: Statement SEMICOLON MultiStatement
| %empty;
ParseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR;
FuncInvocation: ID LPAR FuncArgs RPAR;
FuncArgs: Expr ExtraFuncArgs
| %empty;
ExtraFuncArgs: COMMA Expr ExtraFuncArgs
| %empty;
Expr: Expr OR TerminalExpr
| Expr AND TerminalExpr
| Expr LT TerminalExpr
| Expr GT TerminalExpr
| Expr EQ TerminalExpr
| Expr NE TerminalExpr
| Expr LE TerminalExpr
| Expr GE TerminalExpr
| Expr PLUS TerminalExpr
| Expr MINUS TerminalExpr
| Expr STAR TerminalExpr
| Expr DIV TerminalExpr
| Expr MOD TerminalExpr;
| TerminalExpr;
TerminalExpr: NOT TerminalExpr
| MINUS TerminalExpr
| PLUS TerminalExpr
| INTLIT | REALLIT | ID | FuncInvocation | LPAR Expr RPAR;

%%

void  yyerror (const char *s) {
    printf("%s\n", s);
}

int lex_init(int argc, char **argv);

int main(int argc, char **argv) {
    lex_init(argc, argv);
    yyparse();
    return 0;
}
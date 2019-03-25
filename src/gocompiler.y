%{
    #include <stdio.h>
    int yylex(void);
    void yyerror (const char *s);
%}

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
|;
VarDeclaration: VAR VarSpec;
VarDeclaration: VAR LPAR VarSpec SEMICOLON RPAR;
VarSpec: ID {COMMA ID} Type;
Type: INT | FLOAT32 | BOOL | STRING;
FuncDeclaration: FUNC ID LPAR [Parameters] RPAR [Type] FuncBody;
Parameters: ID Type {COMMA ID Type};
FuncBody: LBRACE VarsAndStatements RBRACE;
VarsAndStatements: VarsAndStatements [VarDeclaration | Statement] SEMICOLON | ;
Statement: ID ASSIGN Expr
| LBRACE MultiStatement RBRACE
| IF Expr LBRACE MultiStatement RBRACE ELSE LBRACE MultiStatement RBRACE
| IF Expr LBRACE MultiStatement RBRACE;
MultiStatement: Statement SEMICOLON MultiStatement
| ;
Statement: FOR [Expr] LBRACE {Statement SEMICOLON} RBRACE;
Statement: RETURN [Expr];
Statement: FuncInvocation | ParseArgs;
Statement: PRINT LPAR (Expr | STRLIT) RPAR;
ParseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR;
FuncInvocation: ID LPAR FuncArgs RPAR;
FuncArgs: Expr ExtraFuncArgs
| ;
ExtraFuncArgs: COMMA Expr ExtraFuncArgs
| ;
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

int main() {
    yyparse();
    return 0;
}
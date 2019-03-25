%{
    #include <stdio.h>
    int yylex(void);
    void yyerror (const char *s);
%}
%token NUMBER

%%

Program		: PACKAGE ID SEMICOLON Declarations;
Declarations	:{VarDeclaration SEMICOLON | FuncDeclaration SEMICOLON};
VarDeclaration	: VAR VarSpec
		| VAR LPAR VarSpec SEMICOLON RPAR;
VarSpec		: ID {COMMA ID} Type;
Type		: INT | FLOAT32 | BOOL | STRING;
FuncDeclaration	: FUNC ID LPAR [Parameters] RPAR [Type] FuncBody;
Parameters	: ID Type {COMMA ID Type};
FuncBody	: LBRACE [VarsAndStatements] RBRACE;
VarsAndStatements	: VarsAndStatements [VarDeclaration | Statement] SEMICOLON;
Statement	: ID ASSIGN Expr
		| LBRACE {Statement SEMICOLON} RBRACE
		| IF Expr LBRACE {Statement SEMICOLON} RBRACE [ELSE LBRACE {Statement SEMICOLON} RBRACE]
		| FOR [Expr] LBRACE {Statement SEMICOLON} RBRACE
		| RETURN [Expr]
		| FuncInvocation | ParseArgs
		| PRINT LPAR (Expr | STRLIT) RPAR;
ParseArgs	: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR;
FuncInvocation	: ID LPAR [Expr {COMMA Expr}] RPAR;
Expr		: Expr (OR | AND) Expr
		| Expr (LT | GT | EQ | NE | LE | GE) Expr
		| Expr (PLUS | MINUS | STAR | DIV | MOD) Expr
		| (NOT | MINUS | PLUS) Expr
		| INTLIT | REALLIT | ID | FuncInvocation | LPAR Expr RPAR;

%%

int main() {
    yyparse();
    return 0;
}


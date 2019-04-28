%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include "nodes.h"
    #include "token.h"
    #include "symtab.h"
    #include "semantics.h"

    int yylex(void);
    void yyerror (const char *s);
    int line, col, yyleng;
    char *yytext;
    int pos;
    extern bool is_string;

    Node *root_node;
    Scope *global;

%}

%union {
    tokeninfo token;
    Node *nodeval;
    node_type typeval;
}

%token <token> ID
%token <token> INTLIT
%token <token> REALLIT
%token <token> STRLIT
%token <token> SEMICOLON
%token <token> BLANKID
%token <token> PACKAGE
%token <token> RETURN
%token <token> AND OR
%token <token> ASSIGN
%token <token> COMMA
%token <token> EQ NE GE GT LE LT
%token <token> LPAR RPAR LBRACE RBRACE LSQ RSQ
%token <token> MINUS PLUS STAR DIV MOD
%token <token> NOT
%token <token> IF ELSE FOR
%token <token> VAR
%token <token> INT
%token <token> FLOAT32
%token <token> BOOL
%token <token> STRING
%token <token> PRINT
%token <token> PARSEINT
%token <token> FUNC
%token <token> CMDARGS
%token <token> RESERVED
%token <token> IMPORTANT

%type <nodeval> Declarations
%type <nodeval> VarDeclaration
%type <nodeval> MultiId
%type <typeval> Type 
%type <nodeval> FuncDeclaration
%type <nodeval> Parameters
%type <nodeval> MultiParam
%type <nodeval> FuncBody
%type <nodeval> VarsAndStatements
%type <nodeval> Statement
%type <nodeval> MultiStatement
%type <nodeval> ParseArgs
%type <nodeval> FuncInvocation
%type <nodeval> FuncArgs
%type <nodeval> MultiFuncArgs
%type <nodeval> Expr

%left OR
%left AND
%left GE GT LE LT EQ NE
%left PLUS MINUS
%left STAR DIV MOD
%precedence IMPORTANT
%precedence PARS

%%

Program: PACKAGE ID SEMICOLON Declarations {
    root_node = new_empty_node(Program);
    append_child(root_node, $4);

};

Declarations: VarDeclaration SEMICOLON Declarations {
    add_neighbour($1,$3);
    $$ = $1;
}
| FuncDeclaration SEMICOLON Declarations {
    add_neighbour($1,$3);
    $$ = $1;
}
| %empty {
    $$ = NULL;
};
VarDeclaration: VAR ID MultiId Type {
    $$ = new_empty_node(VarDecl);
    append_child($$, new_node(Id,$2));
    add_neighbour($$, $3);
    Node *ptr = $$;
    while (ptr != NULL) {
        unshift_child(ptr, new_empty_node($4));
        ptr = ptr->next;
    }
}
| VAR LPAR ID MultiId Type SEMICOLON RPAR {
    $$ = new_empty_node(VarDecl);
    append_child($$, new_node(Id,$3));
    add_neighbour($$, $4);
    Node *ptr = $$;
    while (ptr != NULL) {
        unshift_child(ptr, new_empty_node($5));
        ptr = ptr->next;
    }
};
MultiId: COMMA ID MultiId {
    $$ = new_empty_node(VarDecl);
    append_child($$, new_node(Id,$2));
    add_neighbour($$, $3);
}
| %empty {
    $$ = NULL;
};
Type: INT   {$$ = Int;}
| FLOAT32   {$$ = Float32;}
| BOOL  {$$ = Bool;} 
| STRING    {$$ = String;};
FuncDeclaration: FUNC ID LPAR Parameters RPAR Type FuncBody {
    $$ = new_empty_node(FuncDecl);
    Node *funcheader = new_empty_node(FuncHeader);
    append_child(funcheader, new_node(Id, $2));
    append_child(funcheader, new_empty_node($6));
    Node *funcparams = new_empty_node(FuncParams);
    append_child(funcparams, $4);
    append_child(funcheader, funcparams);
    append_child($$, funcheader);
    append_child($$, $7);
}
| FUNC ID LPAR RPAR Type FuncBody {
    $$ = new_empty_node(FuncDecl);
    Node *funcheader = new_empty_node(FuncHeader);
    append_child(funcheader, new_node(Id, $2));
    append_child(funcheader, new_empty_node($5));
    append_child(funcheader, new_empty_node(FuncParams));
    append_child($$, funcheader);
    append_child($$, $6);
}
| FUNC ID LPAR Parameters RPAR FuncBody {
    $$ = new_empty_node(FuncDecl);
    Node *funcheader = new_empty_node(FuncHeader);
    append_child(funcheader, new_node(Id, $2));
    Node *funcparams = new_empty_node(FuncParams);
    append_child(funcparams, $4);
    append_child(funcheader, funcparams);
    append_child($$, funcheader);
    append_child($$, $6);
}
| FUNC ID LPAR RPAR FuncBody {
    $$ = new_empty_node(FuncDecl);
    Node *funcheader = new_empty_node(FuncHeader);
    append_child(funcheader, new_node(Id, $2));
    append_child(funcheader, new_empty_node(FuncParams));
    append_child($$, funcheader);
    append_child($$, $5);
};
Parameters: ID Type MultiParam {
    $$ = new_empty_node(ParamDecl);
    append_child($$, new_empty_node($2));
    append_child($$, new_node(Id,$1));
    add_neighbour($$, $3);
};
MultiParam: COMMA ID Type MultiParam {
    $$ = new_empty_node(ParamDecl);
    append_child($$, new_empty_node($3));
    append_child($$, new_node(Id,$2));
    add_neighbour($$, $4);
}
| %empty {
    $$ = NULL;
};
FuncBody: LBRACE VarsAndStatements RBRACE {
    $$ = new_empty_node(FuncBody);
    append_child($$, $2);
};
VarsAndStatements: VarsAndStatements SEMICOLON {
    $$ = $1;
}
| VarsAndStatements VarDeclaration SEMICOLON {
    if($1 != NULL){
        $$ = $1;
        add_neighbour($$, $2);
    } else {
        $$ = $2;
    }
}
| VarsAndStatements Statement SEMICOLON {
    if($1 != NULL){
        $$ = $1;
        add_neighbour($$, $2);
    } else {
        $$ = $2;
    }
}
| %empty {
    $$ = NULL;
};
Statement: ID ASSIGN Expr {
    $$ = new_node(Assign, $2);
    append_child($$, new_node(Id, $1));
    append_child($$, $3);
}
| LBRACE MultiStatement RBRACE {
    if (count($2) < 2) {
        $$ = $2;
    } else {
        $$ = new_empty_node(Block);
        append_child($$, $2);
    }
}
| IF Expr LBRACE MultiStatement RBRACE ELSE LBRACE MultiStatement RBRACE {
    $$ = new_empty_node(If);
    append_child($$, $2);
    Node *first_block = new_empty_node(Block);
    append_child(first_block, $4);
    append_child($$, first_block);
    Node *second_block = new_empty_node(Block);
    append_child(second_block, $8);
    append_child($$, second_block);
}
| IF Expr LBRACE MultiStatement RBRACE {
    $$ = new_empty_node(If);
    append_child($$, $2);
    Node *first_block = new_empty_node(Block);
    append_child(first_block, $4);
    append_child($$, first_block);
    append_child($$, new_empty_node(Block));
}
| FOR Expr LBRACE MultiStatement RBRACE {
    $$ = new_empty_node(For);
    append_child($$, $2);
    Node *first_block = new_empty_node(Block);
    append_child(first_block, $4);
    append_child($$, first_block);
}
| FOR LBRACE MultiStatement RBRACE {
    $$ = new_empty_node(For);
    Node *first_block = new_empty_node(Block);
    append_child(first_block, $3);
    append_child($$, first_block);
}
| RETURN Expr {
    $$ = new_empty_node(Return);
    append_child($$, $2);
}
| RETURN {
    $$ = new_empty_node(Return);
}
| FuncInvocation {
    $$ = $1;
}
| ParseArgs {
    $$ = $1;
}
| PRINT LPAR Expr RPAR {
    $$ = new_empty_node(Print);
    append_child($$, $3);
}
| PRINT LPAR STRLIT RPAR {
    $$ = new_empty_node(Print);
    append_child($$, new_node(StrLit, $3));
}
| error {
    $$ = NULL;
};
MultiStatement: Statement SEMICOLON MultiStatement {
    if($1 != NULL){
        $$ = $1;
        add_neighbour($$, $3);
    } else {
        $$ = $3;
    }
}
| %empty {
    $$ = NULL;
};
ParseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR {
    $$ = new_node(ParseArgs, $4);
    append_child($$, new_node(Id, $1));
    append_child($$, $9);
}
| ID COMMA BLANKID ASSIGN PARSEINT LPAR error RPAR {
    $$ = new_empty_node(ParseArgs);
    append_child($$, new_node(Id, $1));
};
FuncInvocation: ID LPAR FuncArgs RPAR {
    $$ = new_empty_node(Call);
    append_child($$, new_node(Id, $1));
    append_child($$, $3);
}
| ID LPAR RPAR {
    $$ = new_empty_node(Call);
    append_child($$, new_node(Id, $1));
}
| ID LPAR error RPAR {
    $$ = new_empty_node(Call);
    append_child($$, new_node(Id, $1));
};
FuncArgs: Expr MultiFuncArgs {
    if($1 != NULL){
        $$ = $1;
        add_neighbour($$, $2);
    } else {
        $$ = $2;
    }
};
MultiFuncArgs: COMMA Expr MultiFuncArgs {
    if($2 != NULL){
        $$ = $2;
        add_neighbour($$, $3);
    } else {
        $$ = $3;
    }
}
| %empty {
    $$ = NULL;
};
Expr: Expr OR Expr {
    $$ = new_node(Or, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr AND Expr {
    $$ = new_node(And, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr LT Expr {
    $$ = new_node(Lt, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr GT Expr {
    $$ = new_node(Gt, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr EQ Expr {
    $$ = new_node(Eq, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr NE Expr {
    $$ = new_node(Ne, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr LE Expr {
    $$ = new_node(Le, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr GE Expr {
    $$ = new_node(Ge, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr PLUS Expr {
    $$ = new_node(Add, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr MINUS Expr {
    $$ = new_node(Sub, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr STAR Expr {
    $$ = new_node(Mul, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr DIV Expr {
    $$ = new_node(Div, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr MOD Expr {
    $$ = new_node(Mod, $2);
    append_child($$,$1);
    append_child($$,$3);
}
| NOT Expr %prec IMPORTANT  {
    $$ = new_node(Not, $1);
    append_child($$,$2);
}
| MINUS Expr %prec IMPORTANT {
    $$ = new_node(Minus, $1);
    append_child($$,$2);
}
| PLUS Expr %prec IMPORTANT {
    $$ = new_node(Plus, $1);
    append_child($$,$2);
}
| INTLIT {
    $$ = new_node(IntLit,$1);
}
| REALLIT {
    $$ = new_node(RealLit,$1);
}
| ID {
    $$ = new_node(Id,$1);
} 
| FuncInvocation {
    $$ = $1;
}
| LPAR Expr RPAR %prec PARS {
    $$ = $2;
}
| LPAR error RPAR %prec PARS {
    $$ = NULL;
};

%%

void  yyerror (const char *s) {
    if (is_string) {
        printf ("Line %d, column %d: %s: \"%s\"\n", line, pos, s, yylval.token.val);
    } else {
        printf ("Line %d, column %d: %s: %s\n", line, col - (int) strlen(yytext), s, yytext);
    }
}

int lex_init(int argc, char **argv);

int main(int argc, char **argv) {
    lex_init(argc, argv);
    if(argc >= 2 && strcmp(argv[1],"-l")==0) {
        yylex();
        return 0;
    } else if(argc >= 2 && strcmp(argv[1],"-t")==0) {
        yyparse();
        print_tree(root_node,0,true);
    } else if(argc >= 2 && strcmp(argv[1],"-s")==0) {
        yyparse();
        global = new_scope("global", false, undef, NULL);
        if(parse_node(root_node, global, global))
            print_errors(root_node);
        else {
            print_scopes(global);
            print_tree(root_node,0,true);
        }
    } else {
        yyparse();
        print_tree(root_node,0,false);
    }
    return 0;
}
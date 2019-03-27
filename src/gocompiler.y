%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    int yylex(void);
    void yyerror (const char *s);
    int line, col, yyleng;
    char *yytext;

    typedef enum {
        Program,
        VarDecl,
        FuncDecl,
        FuncHeader,
        FuncParams,
        FuncBody,
        ParamDecl,
        Block,
        If,
        For,
        Return,
        Call,
        Print,
        ParseArgs,
        Or,
        And,
        Eq,
        Ne,
        Lt,
        Gt,
        Le,
        Ge,
        Add,
        Sub,
        Mul,
        Div,
        Mod,
        Not,
        Minus,
        Plus,
        Assign,
        Int,
        Float32,
        Bool,
        String,
        IntLit,
        RealLit,
        Id,
        StrLit
    } node_type;

    typedef struct node;

    typedef struct node{
        node_type type;
        int intval;
        double realval;
        char* strval;
        Node *children;
        Node *next;
    } Node;

    Node *new_node(node_type type, YYSTYPE val) {
        Node *n = (Node *) malloc(sizeof(Node));
        node->children = NULL;
        node->next = NULL;
        n->type = type;
        if (type == Id || type == StrLit)
            n->strval = strdup(val->strval);
        if (type == IntLit)
            n->intval = val->intval;
        if (type == RealLit)
            n->realval = val->realval;
        return n;
    }


    Node *new_empty_node(node_type type) {
        Node *n = (Node *) malloc(sizeof(Node));
        node->children = NULL;
        node->next = NULL;
        n->type = type;
        return n;
    }

    void append_child(Node *parent, Node *child) {
        Node *ptr = parent->children;
        if (ptr = NULL)
            parent->children = child;
        else {
            while (ptr->next != NULL) ptr = ptr->next;
            ptr->next = child;
        }
    }
    void unshift_child(Node *parent, Node *child) {
        child->next = parent->children;
        parent->children = child;
    }
    
    void add_neighbour(Node *child, Node *new_child) {
        Node *ptr = child;
        while (ptr->next != NULL) ptr = ptr->next;
        ptr->next = new_child;
    }

    int count(Node *n) {
        int i = 0;
        for(Node *ptr = n; ptr != NULL; ptr = ptr->next){
            i++;
        }
        return i;
    }

    Node root_node;

%}

/*
%define parse.error verbose
*/

%union {
    int intval;
    double realval;
    char* strval;
}

%token <strval> ID
%token <intval> INTLIT
%token <realval> REALLIT
%token <strval> STRLIT
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

%left AND OR
%left GE GT LE LT EQ NE
%left PLUS MINUS
%left STAR DIV MOD
%precedence IMPORTANT

%%

Program: PACKAGE ID SEMICOLON Declarations {
    root_node = new_empty_node(Program);
    append_child(&root_node, $4);

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
    $$ = NULL
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
    append_child(funcheader, $4);
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
    append_child(funcheader, $4);
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
VarsAndStatements: SEMICOLON VarsAndStatements {
    $$ = $2;
}
| VarDeclaration SEMICOLON VarsAndStatements {
    $$ = $1;
    add_neighbour($$, $3);
}
| Statement SEMICOLON VarsAndStatements {
    $$ = $1;
    add_neighbour($$, $3);
}
| %empty {
    $$ = NULL;
};
Statement: ID ASSIGN Expr {
    $$ = new_empty_node(Assign);
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
    append_child($$, $1);
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
    $$ = $1;
    add_neighbour($$, $3);
}
| %empty {
    $$ = NULL;
};
ParseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR {
    $$ = new_empty_node(ParseArgs);
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
    $$ = $1;
    add_neighbour($$, $2);
};
MultiFuncArgs: COMMA Expr MultiFuncArgs {
    $$ = $2;
    add_neighbour($$, $3);
}
| %empty {
    $$ = NULL;
};
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
%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <stdbool.h>
    int yylex(void);
    void yyerror (const char *s);
    int line, col, yyleng;
    char *yytext;
    int pos;
    extern bool is_string;

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

    typedef struct node Node;

    typedef struct node{
        node_type type;
        int intval;
        double realval;
        char* strval;
        Node *children;
        Node *next;
    } node_t;

    Node *new_int_node(int type, int val) {
        Node *n = (Node *) malloc(sizeof(Node));
        n->children = NULL;
        n->next = NULL;
        n->type = (node_type) type;
        n->intval = val;
        return n;
    }

    Node *new_str_node(int type, char *val) {
        Node *n = (Node *) malloc(sizeof(Node));
        n->children = NULL;
        n->next = NULL;
        n->type = (node_type) type;
        n->strval = strdup(val);
        return n;
    }


    Node *new_empty_node(int type) {
        Node *n = (Node *) malloc(sizeof(Node));
        n->children = NULL;
        n->next = NULL;
        n->type = (node_type) type;
        return n;
    }

    void append_child(void *parent, void *child) {
        Node *ptr =  ((Node *) parent)->children;
        if (ptr == NULL)
            ((Node *) parent)->children = (Node *) child;
        else {
            while (ptr->next != NULL) ptr = ptr->next;
            ptr->next = (Node *) child;
        }
    }
    void unshift_child(void *parent, void *child) {
        ((Node *) child)->next = ((Node *) parent)->children;
        ((Node *) parent)->children = (Node *) child;
    }
    
    void add_neighbour(void *child, void *new_child) {
        Node *ptr = (Node *) child;
        while (ptr->next != NULL) ptr = ptr->next;
        ptr->next = (Node *) new_child;
    }

    int count(void *n) {
        int i = 0;
        for(Node *ptr = (Node *) n; ptr != NULL; ptr = ptr->next){
            i++;
        }
        return i;
    }

    void print_tree(Node *n, int level) {
        if (n != NULL) {
            for (int i = 0; i < level; i++)
                printf("..");
            switch(n->type) {
                case Program: printf("Program"); break;
                case VarDecl: printf("VarDecl"); break; 
                case FuncDecl: printf("FuncDecl"); break; 
                case FuncHeader: printf("FuncHeader"); break; 
                case FuncParams: printf("FuncParams"); break; 
                case FuncBody: printf("FuncBody"); break; 
                case ParamDecl: printf("ParamDecl"); break; 
                case Block: printf("Block"); break; 
                case If: printf("If"); break; 
                case For: printf("For"); break; 
                case Return: printf("Return"); break; 
                case Call: printf("Call"); break; 
                case Print: printf("Print"); break; 
                case ParseArgs: printf("ParseArgs"); break; 
                case Or: printf("Or"); break; 
                case And: printf("And"); break; 
                case Eq: printf("Eq"); break; 
                case Ne: printf("Ne"); break; 
                case Lt: printf("Lt"); break; 
                case Gt: printf("Gt"); break; 
                case Le: printf("Le"); break; 
                case Ge: printf("Ge"); break; 
                case Add: printf("Add"); break; 
                case Sub: printf("Sub"); break; 
                case Mul: printf("Mul"); break; 
                case Div: printf("Div"); break; 
                case Mod: printf("Mod"); break; 
                case Not: printf("Not"); break; 
                case Minus: printf("Minus"); break; 
                case Plus: printf("Plus"); break; 
                case Assign: printf("Assign"); break; 
                case Int: printf("Int"); break; 
                case Float32: printf("Float32"); break; 
                case Bool: printf("Bool"); break; 
                case String: printf("String"); break; 
                case IntLit: printf("IntLit(%d)", n->intval); break; 
                case RealLit: printf("RealLit(%s)", n->strval); break; 
                case Id: printf("Id(%s)", n->strval); break; 
                case StrLit: printf("StrLit(\"%s\")", n->strval); break;
            }
            printf("\n");
            print_tree(n->children, level + 1);
            print_tree(n->next, level);
        }
    }

    Node *root_node;

%}

/*
%define parse.error verbose
*/

%union {
    int intval;
    double realval;
    char *strval;
    void *nodeval;
    int typeval;
}

%token <strval> ID
%token <intval> INTLIT
%token <strval> REALLIT
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
    append_child($$, new_str_node(Id,$2));
    add_neighbour($$, $3);
    Node *ptr = $$;
    while (ptr != NULL) {
        unshift_child(ptr, new_empty_node($4));
        ptr = ptr->next;
    }
}
| VAR LPAR ID MultiId Type SEMICOLON RPAR {
    $$ = new_empty_node(VarDecl);
    append_child($$, new_str_node(Id,$3));
    add_neighbour($$, $4);
    Node *ptr = $$;
    while (ptr != NULL) {
        unshift_child(ptr, new_empty_node($5));
        ptr = ptr->next;
    }
};
MultiId: COMMA ID MultiId {
    $$ = new_empty_node(VarDecl);
    append_child($$, new_str_node(Id,$2));
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
    append_child(funcheader, new_str_node(Id, $2));
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
    append_child(funcheader, new_str_node(Id, $2));
    append_child(funcheader, new_empty_node($5));
    append_child(funcheader, new_empty_node(FuncParams));
    append_child($$, funcheader);
    append_child($$, $6);
}
| FUNC ID LPAR Parameters RPAR FuncBody {
    $$ = new_empty_node(FuncDecl);
    Node *funcheader = new_empty_node(FuncHeader);
    append_child(funcheader, new_str_node(Id, $2));
    Node *funcparams = new_empty_node(FuncParams);
    append_child(funcparams, $4);
    append_child(funcheader, funcparams);
    append_child($$, funcheader);
    append_child($$, $6);
}
| FUNC ID LPAR RPAR FuncBody {
    $$ = new_empty_node(FuncDecl);
    Node *funcheader = new_empty_node(FuncHeader);
    append_child(funcheader, new_str_node(Id, $2));
    append_child(funcheader, new_empty_node(FuncParams));
    append_child($$, funcheader);
    append_child($$, $5);
};
Parameters: ID Type MultiParam {
    $$ = new_empty_node(ParamDecl);
    append_child($$, new_empty_node($2));
    append_child($$, new_str_node(Id,$1));
    add_neighbour($$, $3);
};
MultiParam: COMMA ID Type MultiParam {
    $$ = new_empty_node(ParamDecl);
    append_child($$, new_empty_node($3));
    append_child($$, new_str_node(Id,$2));
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
    if($1 != NULL){
        $$ = $1;
        add_neighbour($$, $3);
    } else {
        $$ = $3;
    }
}
| Statement SEMICOLON VarsAndStatements {
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
Statement: ID ASSIGN Expr {
    $$ = new_empty_node(Assign);
    append_child($$, new_str_node(Id, $1));
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
    append_child($$, new_str_node(StrLit, $3));
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
    $$ = new_empty_node(ParseArgs);
    append_child($$, new_str_node(Id, $1));
    append_child($$, $9);
}
| ID COMMA BLANKID ASSIGN PARSEINT LPAR error RPAR {
    $$ = new_empty_node(ParseArgs);
    append_child($$, new_str_node(Id, $1));
};
FuncInvocation: ID LPAR FuncArgs RPAR {
    $$ = new_empty_node(Call);
    append_child($$, new_str_node(Id, $1));
    append_child($$, $3);
}
| ID LPAR RPAR {
    $$ = new_empty_node(Call);
    append_child($$, new_str_node(Id, $1));
}
| ID LPAR error RPAR {
    $$ = new_empty_node(Call);
    append_child($$, new_str_node(Id, $1));
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
    $$ = new_empty_node(Or);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr AND Expr {
    $$ = new_empty_node(And);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr LT Expr {
    $$ = new_empty_node(Lt);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr GT Expr {
    $$ = new_empty_node(Gt);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr EQ Expr {
    $$ = new_empty_node(Eq);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr NE Expr {
    $$ = new_empty_node(Ne);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr LE Expr {
    $$ = new_empty_node(Le);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr GE Expr {
    $$ = new_empty_node(Ge);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr PLUS Expr {
    $$ = new_empty_node(Add);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr MINUS Expr {
    $$ = new_empty_node(Sub);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr STAR Expr {
    $$ = new_empty_node(Mul);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr DIV Expr {
    $$ = new_empty_node(Div);
    append_child($$,$1);
    append_child($$,$3);
}
| Expr MOD Expr {
    $$ = new_empty_node(Mod);
    append_child($$,$1);
    append_child($$,$3);
}
| NOT Expr %prec IMPORTANT  {
    $$ = new_empty_node(Not);
    append_child($$,$2);
}
| MINUS Expr %prec IMPORTANT {
    $$ = new_empty_node(Minus);
    append_child($$,$2);
}
| PLUS Expr %prec IMPORTANT {
    $$ = new_empty_node(Plus);
    append_child($$,$2);
}
| INTLIT {
    $$ = new_int_node(IntLit,$1);
}
| REALLIT {
    $$ = new_str_node(RealLit,$1);
}
| ID {
    $$ = new_str_node(Id,$1);
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
        printf ("Line %d, column %d: %s: \"%s\"\n", line, pos, s, yylval.strval);
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
        print_tree(root_node,0);
    } else {
        yyparse();
    }
    return 0;
}
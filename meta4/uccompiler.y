
%{
    /*
        Rui Pedro Costa Linhares 2015227420
        Tiago Guilherme Lopes Gomes 2015245562
    */
    #include <stdio.h>
    #include <stdlib.h>  
    #include <string.h> 
    #include "tree.h"
    
    int commaFlag = 0;
    int numNode = 0;
    extern int errorFlag;
    extern int flag;
    extern node nodeTree;
    int yylex(void);
    void yyerror (char * s);
    
    char * auxType;
    node nodeAux;
    node insertNode(char * id, char * type, node nodeSon)
    {
        node auxNode = (node)malloc(sizeof(no));
        auxNode->type = type;
        auxNode->id = id;
        auxNode->nodeSon = nodeSon;
        auxNode->nodeBrother = NULL;
        auxNode->note = "";

        return auxNode;
    }

    void printTree(node auxNode, int pontos)
    {
        int i, call=0;

        if (auxNode!=NULL){

            if (auxNode->type!=NULL && strcmp(auxNode->type,"Comma")==0 && commaFlag == 1){
                if (auxNode->nodeSon != NULL){
                    printTree(auxNode->nodeSon,pontos);  
                }
            }
            else if (auxNode->type!=NULL && strcmp(auxNode->type,"Aux")==0){
                if (commaFlag==1){
                    commaFlag = 0;
                    if (auxNode->nodeSon != NULL)
                        printTree(auxNode->nodeSon,pontos); 
                    commaFlag = 1;    
                }
                else
                    if (auxNode->nodeSon != NULL)
                        printTree(auxNode->nodeSon,pontos);    
            }

            else{
                if (auxNode->id != NULL && strcmp(auxNode->id,"type")==0){
                    for (i = 0; i < pontos-2; i++)
                        printf(".");
                    
                    printf("%s%s\n", auxNode->type,auxNode->note);
                    for (i = 0; i < pontos; i++)
                        printf(".");
                    printf("%s%s\n",auxType,auxNode->note);
                
                    if (auxNode->nodeSon != NULL)
                        printTree(auxNode->nodeSon,pontos);  
                            
                }
                
                else if (auxNode->type != NULL){
                    
                    if (strcmp(auxNode->type,"Call")==0){
                        call = 1;
                        commaFlag = 1;
                    }
                    
                    if (strcmp(auxNode->type,"Declaration")==0)
                        auxType = auxNode->nodeSon->type;

                    for (i = 0; i < pontos; i++)
                        printf(".");
                    if (auxNode->id != NULL) 
                        printf("%s(%s)%s\n", auxNode->type, auxNode->id,auxNode->note);
                    else   
                        printf("%s%s\n", auxNode->type,auxNode->note);
                    
                    if (auxNode->nodeSon != NULL){
                        pontos+=2;
                        printTree(auxNode->nodeSon,pontos);
                        pontos-=2;
                    }
                    if (call==1)
                        commaFlag=0;  
                }
                else
                    if (auxNode->nodeSon != NULL)
                        printTree(auxNode->nodeSon,pontos);
            }
            if (auxNode->nodeBrother != NULL)
                    printTree(auxNode->nodeBrother,pontos);   
        }  
        //free(auxNode);
    }

    void linkBrother(node node1, node node2)
    {
        node1->nodeBrother = node2;
    }
%}

%union{
    struct no * node;
    char * id;
}

%token <id> ID
%token <id> INTLIT
%token <id> REALLIT
%token <id> CHRLIT

%type <node> FunctionsAndDeclarations
%type <node> FunctionDefinition
%type <node> FunctionBody
%type <node> DeclarationsAndStatements
%type <node> FunctionDeclaration
%type <node> FunctionDeclarator
%type <node> ParameterList
%type <node> ParameterDeclaration
%type <node> Declaration
%type <node> DeclarationAUX
%type <node> TypeSpec
%type <node> Declarator
%type <node> Statement
%type <node> StatementERROR
%type <node> StatementAUX
%type <node> Expr
%type <node> ExprOperations
%type <node> ExprLogical
%type <node> ExprRelation
%type <node> ExprUnary
%type <node> ExprFunction
%type <node> ExprPrimary
%type <node> Program

%token CHAR 
%token ELSE
%token WHILE
%token IF
%token INT 
%token SHORT
%token DOUBLE
%token RETURN
%token VOID
%token BITWISEAND
%token BITWISEOR
%token BITWISEXOR
%token AND
%token ASSIGN
%token MUL
%token COMMA
%token DIV
%token EQ
%token GE
%token GT
%token LBRACE
%token LE
%token LPAR
%token LT
%token MINUS
%token MOD
%token NE
%token NOT
%token OR
%token PLUS
%token RBRACE
%token RPAR
%token SEMI
%token RESERVED


%left COMMA
%right ASSIGN
%left OR
%left AND
%left BITWISEOR
%left BITWISEXOR
%left BITWISEAND
%left EQ NE
%left LE LT GT GE
%left PLUS MINUS
%left MUL DIV MOD
%right NOT
%left RPAR LPAR

%nonassoc ELSE


%%

Program: FunctionsAndDeclarations                   {nodeTree = insertNode(NULL,"Program",$1);}
    ;

FunctionsAndDeclarations:                           
        FunctionDefinition                          {$$ = $1;}
    |   FunctionDeclaration                         {$$ = $1;}
    |   Declaration                                 {$$ = $1;}
    |   FunctionDefinition FunctionsAndDeclarations {linkBrother($1,$2);
                                                    $$ = $1;
                                                    }
    |   FunctionDeclaration FunctionsAndDeclarations{linkBrother($1,$2);$$ = $1;
                                                    }
    |   Declaration FunctionsAndDeclarations        {linkBrother($1,$2);$$ = $1;
                                                    }
    ;

FunctionDefinition:
        TypeSpec FunctionDeclarator FunctionBody    {
                                                    $$ = insertNode(NULL,"FuncDefinition",$1);
                                                    linkBrother($1,$2);
                                                    linkBrother($2,$3);
                                                    }
    ;

FunctionBody: 
        LBRACE  RBRACE                              {$$ = insertNode(NULL,"FuncBody",NULL);}                              
    |   LBRACE DeclarationsAndStatements RBRACE     {$$ = insertNode(NULL,"FuncBody",$2);}
    ;

DeclarationsAndStatements:
        Statement DeclarationsAndStatements         {if($1!=NULL){
                                                        $$ = $1;
                                                        if ($2!=NULL)
                                                            linkBrother($1,$2);
                                                    }else{
                                                        $$ = $2;
                                                    }
                                                    }
    |   Declaration DeclarationsAndStatements       {linkBrother($1,$2);
                                                    $$ = $1;}
    |   Statement                                   {
                                                    $$ = $1;
                                                    }
    |   Declaration                                 {$$ = $1;}
    ;

FunctionDeclaration:
        TypeSpec FunctionDeclarator SEMI            {linkBrother($1,$2); 
                                                    $$ = insertNode(NULL,"FuncDeclaration",$1);
                                                    }
    ;

FunctionDeclarator:
        ID LPAR ParameterList RPAR                  {nodeAux = insertNode($1,"Id",NULL);
                                                    linkBrother(nodeAux,insertNode(NULL,"ParamList",$3));
                                                    $$ = insertNode(NULL,NULL,nodeAux);
                                                    }
    ;

ParameterList:
        ParameterDeclaration                        {$$ = $1;}
    |   ParameterDeclaration COMMA ParameterList    {linkBrother($1,$3);
                                                    $$ = $1;
                                                    }
    ;

ParameterDeclaration:
        TypeSpec                                    {$$ = insertNode(NULL,"ParamDeclaration",$1);}
    |   TypeSpec ID                                 {nodeAux = insertNode($2,"Id",NULL);
                                                    linkBrother($1,nodeAux);
                                                    $$ = insertNode(NULL,"ParamDeclaration",$1);}
    ;

Declaration:
        TypeSpec Declarator SEMI                    {linkBrother($1,$2);
                                                    $$ = insertNode(NULL,"Declaration",$1);
                                                    }
    |   TypeSpec Declarator DeclarationAUX SEMI     {linkBrother($1,$2);
                                                    nodeAux = $2;
                                                    while (nodeAux->nodeBrother!=NULL)
                                                        nodeAux = nodeAux->nodeBrother;
                                                    nodeAux->nodeBrother = $3; 
                                                                                       
                                                    $$ = insertNode(NULL,"Declaration",$1);                                    
                                                    }
    |   error SEMI                                  {$$ = insertNode(NULL,NULL,NULL);errorFlag=1;}
    ;

DeclarationAUX:
        COMMA Declarator                            {$$ = insertNode("type","Declaration",$2);
                                                    }
    |   COMMA Declarator DeclarationAUX             {
                                                    $$ = insertNode("type","Declaration",$2);
                                                    nodeAux = $$;
                                                    while (nodeAux->nodeBrother!=NULL)
                                                        nodeAux = nodeAux->nodeBrother;
                                                    nodeAux->nodeBrother = $3; 
                                                    }
    ;

TypeSpec:
        CHAR                                        {$$ = insertNode(NULL,"Char",NULL);}
    |   INT                                         {$$ = insertNode(NULL,"Int",NULL);}
    |   VOID                                        {$$ = insertNode(NULL,"Void",NULL);}
    |   SHORT                                       {$$ = insertNode(NULL,"Short",NULL);}
    |   DOUBLE                                      {$$ = insertNode(NULL,"Double",NULL);}
    ;

Declarator:
        ID                                          {$$ = insertNode($1,"Id",NULL);}
    |   ID ASSIGN Expr                              {
                                                    $$ = insertNode($1,"Id",NULL);
                                                    nodeAux = $$;
                                                    while (nodeAux->nodeBrother!=NULL)
                                                        nodeAux = nodeAux->nodeBrother;
                                                    nodeAux->nodeBrother = $3;  
                                                    }
    ;

Statement:
        SEMI                                        {$$ = NULL;}                                                
    |   Expr SEMI                                   {$$ = $1;}
    |   LBRACE RBRACE                               {$$ = NULL;}
    |   LBRACE error RBRACE                         {$$ = insertNode(NULL,NULL,NULL);errorFlag=1;}
    |   LBRACE StatementAUX RBRACE                  {$$ = $2;
                                                    if ($2!=NULL && $2->nodeBrother!=NULL) $$ = insertNode(NULL,"StatList",$2);
                                                    }
    |   IF LPAR Expr RPAR StatementERROR         {
                                                    if($5==NULL) $5=insertNode(NULL,"Null",NULL);
                                                    linkBrother($3,$5);   
                                                    nodeAux = insertNode(NULL,"Null",NULL);
                                                    linkBrother($5,nodeAux);
                                                    $$ = insertNode(NULL,"If",$3);}
    |   IF LPAR Expr RPAR StatementERROR ELSE StatementERROR    {
                                                    if($5==NULL) $5=insertNode(NULL,"Null",NULL);
                                                    if($7==NULL) $7=insertNode(NULL,"Null",NULL);
                                                    linkBrother($3,$5);
                                                    linkBrother($5,$7);
                                                    $$ = insertNode(NULL,"If",$3);
                                                    }
    |   WHILE LPAR Expr RPAR StatementERROR         {
                                                    if($5==NULL) $5=insertNode(NULL,"Null",NULL);
                                                    linkBrother($3,$5);                                                
                                                    $$ = insertNode(NULL,"While",$3);}
    |   RETURN SEMI                                 {$$ = insertNode(NULL,"Return",insertNode(NULL,"Null",NULL));
                                                    }
    |   RETURN Expr SEMI                            {$$ = insertNode(NULL,"Return",$2);
                                                    }
    ;

StatementERROR:     
        Statement                                   { $$ = $1;
                                                    }
    |   error SEMI                                  {$$ = insertNode(NULL,NULL,NULL);errorFlag=1;} 

    ;        

StatementAUX:
        StatementERROR StatementAUX                 {if($1!=NULL){
                                                        $$ = $1;
                                                        if ($2!=NULL)
                                                            linkBrother($1,$2);
                                                    }else
                                                        $$ = $2;
                                                    }    
    |   StatementERROR                              {$$ = $1;}
    ;

Expr:
        Expr ASSIGN Expr                            {
                                                    $$ = insertNode(NULL,"Store",$1);
                                                    linkBrother($1,$3);}       
    |   Expr COMMA Expr                             {
                                                    $$ = insertNode(NULL,"Comma",$1);
                                                    linkBrother($1,$3);
                                                    } 
    |   LPAR error RPAR                             {$$ = insertNode(NULL,NULL,NULL);errorFlag=1;}
    |   ID LPAR error RPAR                          {$$ = insertNode(NULL,NULL,NULL);errorFlag=1;}
    |   ExprOperations                              
    |   ExprLogical                                 
    |   ExprRelation                                
    |   ExprUnary                                   
    |   ExprFunction                                {$$ = insertNode(NULL,"Call",$1);}
    |   ExprPrimary                                 
    ;

ExprOperations:
        Expr PLUS Expr                              {linkBrother($1,$3);$$ = insertNode(NULL,"Add",$1);} 
    |   Expr MINUS Expr                             {linkBrother($1,$3);$$ = insertNode(NULL,"Sub",$1);} 
    |   Expr MUL Expr                               {linkBrother($1,$3);$$ = insertNode(NULL,"Mul",$1);} 
    |   Expr DIV Expr                               {linkBrother($1,$3);$$ = insertNode(NULL,"Div",$1);} 
    |   Expr MOD Expr                               {linkBrother($1,$3);$$ = insertNode(NULL,"Mod",$1);} 
    ;  

ExprLogical:
        Expr OR Expr                                {linkBrother($1,$3);$$ = insertNode(NULL,"Or",$1);} 
    |   Expr AND Expr                               {linkBrother($1,$3);$$ = insertNode(NULL,"And",$1);} 
    |   Expr BITWISEAND Expr                        {linkBrother($1,$3);$$ = insertNode(NULL,"BitWiseAnd",$1);} 
    |   Expr BITWISEOR Expr                         {linkBrother($1,$3);$$ = insertNode(NULL,"BitWiseOr",$1);} 
    |   Expr BITWISEXOR Expr                        {linkBrother($1,$3);$$ = insertNode(NULL,"BitWiseXor",$1);} 
    ;

ExprRelation:
        Expr EQ Expr                                {linkBrother($1,$3);$$ = insertNode(NULL,"Eq",$1);} 
    |   Expr NE Expr                                {linkBrother($1,$3);$$ = insertNode(NULL,"Ne",$1);} 
    |   Expr LE Expr                                {linkBrother($1,$3);$$ = insertNode(NULL,"Le",$1);} 
    |   Expr GE Expr                                {linkBrother($1,$3);$$ = insertNode(NULL,"Ge",$1);} 
    |   Expr LT Expr                                {linkBrother($1,$3);$$ = insertNode(NULL,"Lt",$1);} 
    |   Expr GT Expr                                {linkBrother($1,$3);$$ = insertNode(NULL,"Gt",$1);} 
    ;

ExprUnary:
        PLUS Expr %prec NOT                         {$$ = insertNode(NULL,"Plus",$2);} 
    |   MINUS Expr %prec NOT                        {$$ = insertNode(NULL,"Minus",$2);} 
    |   NOT Expr                                    {$$ = insertNode(NULL,"Not",$2);} 
    ;

ExprFunction:
        ID LPAR RPAR                                {$$ = insertNode($1,"Id",NULL);
                                                    } 
    |   ID LPAR Expr RPAR                           {$$ = insertNode($1,"Id",NULL);
                                                    linkBrother($$,$3);
                                                    } 
    ;

ExprPrimary:
        ID                                          {$$ = insertNode($1,"Id",NULL);} 
    |   INTLIT                                      {$$ = insertNode($1,"IntLit",NULL);} 
    |   REALLIT                                     {$$ = insertNode($1,"RealLit",NULL);} 
    |   CHRLIT                                      {$$ = insertNode($1,"ChrLit",NULL);} 
    |   LPAR Expr RPAR                              {$$ = insertNode(NULL,"Aux",$2);} 
    ;

%%

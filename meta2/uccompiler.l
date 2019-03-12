%{
    /*
        Rui Pedro Costa Linhares 2015227420
        Tiago Guilherme Lopes Gomes 2015245562
    */

    #include "y.tab.h"
    
    int linha=1;
    int coluna=1;
    int auxC=1;
    int auxL=1;
    int flag=0;
%}
%X COMMENT

BAR             \\\\
ASPAS           \\\"
PLICA           \\\'
OCTO            \\[0-7]{1,3}
ENTER           \\n
TAB             \\t
ELSE            else
WHILE           while
IF              if
INT             int
SHORT           short
DOUBLE          double
RETURN          return
VOID            void
CHAR            char
END             <<EOF>>
BITWISEAND      "&"
BITWISEOR       "|"
BITWISEXOR      "^"
AND             "&&"
ASSIGN          "="
MUL             "*"
COMMA           ","
DIV             "/"
EQ              "=="
GE              ">="
GT              ">"
LBRACE          "{"
LE              "<="
LPAR            "("
LT              "<"
MINUS           "-"
MOD             "%"
NE              "!="
NOT             "!"
OR              "||"
PLUS            "+"
RBRACE          "}"
RPAR            ")"
SEMI            ";"
SPACE           ([ ]|"\t")
INTLIT          [0-9]+
ID              [a-zA-Z\_][a-zA-Z\_0-9]*
CHRLIT          ([^\n\'\\]|{OCTO}|{ENTER}|{TAB}|{BAR}|{ASPAS}|{PLICA})
EXPOENTE        (e|E)("+"|"-")?{INTLIT}
REALLIT         (({INTLIT}".")|({INTLIT}"."{INTLIT})|{INTLIT}"."{INTLIT}{EXPOENTE}|{INTLIT}"."{EXPOENTE}|"."{INTLIT}{EXPOENTE}|{INTLIT}{EXPOENTE}|"."{INTLIT})
RESERVED        "auto"|"break"|"const"|"continue"|"asm"|"do"|"enum"|"extern"|"float"|"for"|"goto"|"register"|"long"|"signed"|"unsigned"|"sizeof"|"static"|"struct"|"switch"|"case"|"default"|"typedef"|"union"|"volatile"|"break"|"_Bool"|"_Imaginary"|"restrict"|"inline"|"_Complex"|"["|"]"|"++"|"--"

%%
\/\/.*            {coluna+=yyleng;}
\/\*              { BEGIN COMMENT;auxC=coluna;auxL=linha;coluna+=yyleng;}
<COMMENT>.        {coluna+=yyleng;}
<COMMENT>\n       {linha++;coluna=1;}
<COMMENT>\*\/     { BEGIN 0;coluna+=yyleng;}
<COMMENT><<EOF>>  { BEGIN 0;printf("Line %d, col %d: unterminated comment\n",auxL,auxC);yyterminate();}
<<EOF>>           {coluna+=yyleng;yyterminate();}
{CHAR}            {if(flag==1)printf("CHAR\n");coluna+=yyleng;
                  return CHAR;}
{ELSE}            {if(flag==1)printf("ELSE\n");coluna+=yyleng;
                  return ELSE;}
{WHILE}           {if(flag==1)printf("WHILE\n");coluna+=yyleng;
                  return WHILE;}
{IF}              {if(flag==1)printf("IF\n");coluna+=yyleng;
                  return IF;}
{INT}             {if(flag==1)printf("INT\n");coluna+=yyleng;
                  return INT;}
{SHORT}           {if(flag==1)printf("SHORT\n");coluna+=yyleng;
                  return SHORT;}
{DOUBLE}          {if(flag==1)printf("DOUBLE\n");coluna+=yyleng;
                  return DOUBLE;}
{RETURN}          {if(flag==1)printf("RETURN\n");coluna+=yyleng;
                  return RETURN;}
{VOID}            {if(flag==1)printf("VOID\n");coluna+=yyleng;
                  return VOID;}
{BITWISEAND}      {if(flag==1)printf("BITWISEAND\n");coluna+=yyleng;
                  return BITWISEAND;}
{BITWISEOR}       {if(flag==1)printf("BITWISEOR\n");coluna+=yyleng;
                  return BITWISEOR;}
{BITWISEXOR}      {if(flag==1)printf("BITWISEXOR\n");coluna+=yyleng;
                  return BITWISEXOR;}
{AND}             {if(flag==1)printf("AND\n");coluna+=yyleng;
                  return AND;}
{ASSIGN}          {if(flag==1)printf("ASSIGN\n");coluna+=yyleng;
                  return ASSIGN;}
{MUL}             {if(flag==1)printf("MUL\n");coluna+=yyleng;
                  return MUL;}
{COMMA}           {if(flag==1)printf("COMMA\n");coluna+=yyleng;
                  return COMMA;}
{DIV}             {if(flag==1)printf("DIV\n");coluna+=yyleng;
                  return DIV;}
{EQ}              {if(flag==1)printf("EQ\n");coluna+=yyleng;
                  return EQ;}
{GE}              {if(flag==1)printf("GE\n");coluna+=yyleng;
                  return GE;}
{GT}              {if(flag==1)printf("GT\n");coluna+=yyleng;
                  return GT;}
{LBRACE}          {if(flag==1)printf("LBRACE\n");coluna+=yyleng;
                  return LBRACE;}
{LE}              {if(flag==1)printf("LE\n");coluna+=yyleng;
                  return LE;}
{LPAR}            {if(flag==1)printf("LPAR\n");coluna+=yyleng;
                  return LPAR;}
{LT}              {if(flag==1)printf("LT\n");coluna+=yyleng;
                  return LT;}
{MINUS}           {if(flag==1)printf("MINUS\n");coluna+=yyleng;
                  return MINUS;}
{MOD}             {if(flag==1)printf("MOD\n");coluna+=yyleng;
                  return MOD;}
{NE}              {if(flag==1)printf("NE\n");coluna+=yyleng;
                  return NE;}
{NOT}             {if(flag==1)printf("NOT\n");coluna+=yyleng;
                  return NOT;}
{OR}              {if(flag==1)printf("OR\n");coluna+=yyleng;
                  return OR;}
{PLUS}            {if(flag==1)printf("PLUS\n");coluna+=yyleng;
                  return PLUS;}
{RBRACE}          {if(flag==1)printf("RBRACE\n");coluna+=yyleng;
                  return RBRACE;}
{RPAR}            {if(flag==1)printf("RPAR\n");coluna+=yyleng;
                  return RPAR;}
{SEMI}            {if(flag==1)printf("SEMI\n");coluna+=yyleng;
                  return SEMI;}
{RESERVED}        {if(flag==1)printf("RESERVED(%s)\n",yytext);coluna+=yyleng;
                  return RESERVED;}
{ID}              {if(flag==1)printf("ID(%s)\n",yytext);coluna+=yyleng;
                  yylval.id = strdup(yytext);
                  return ID;}
{INTLIT}          {if(flag==1)printf("INTLIT(%s)\n",yytext);coluna+=yyleng;
                  yylval.id = strdup(yytext);
                  return INTLIT;}
{REALLIT}         {if(flag==1)printf("REALLIT(%s)\n",yytext);coluna+=yyleng;
                  yylval.id = strdup(yytext);
                  return REALLIT;}
\'{CHRLIT}\'      {if(flag==1)printf("CHRLIT(%s)\n",yytext);coluna+=yyleng;
                  yylval.id = strdup(yytext);
                  return CHRLIT;}
\'([^\n\'\\]|\\.)*\'  {printf("Line %d, col %d: invalid char constant (%s)\n",linha,coluna,yytext);coluna+=yyleng;}
\'([^\n\'\\]|\\.)*(\\)?    {printf("Line %d, col %d: unterminated char constant\n",linha,coluna);coluna+=yyleng;}
{SPACE}           {coluna+=yyleng;}
\n|"\r\n"|"\r"    {linha++;coluna=1;}
.                 {printf("Line %d, col %d: illegal character (%s)\n",linha,coluna,yytext);coluna+=yyleng;}
%%


int yywrap()
{
    return 1;
}

void yyerror (char *s)
{
    printf("Line %d, col %d: %s: %s\n",linha,coluna-(int)yyleng,s,yytext);
}


int main(int argc, char **argv)
{
    if (argc>1){
        if (argv[1][0]=='-' && argv[1][1]=='l'){
            flag=1;
            yylex();
        }
        else if (argv[1][0]=='-' && argv[1][1]=='t'){
            flag=2;
        }
    }
    yyparse();
    return 0;
}

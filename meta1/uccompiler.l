%{
    /*
        Rui Pedro Costa Linhares 2015227420
        Tiago Guilherme Lopes Gomes 2015245562
    */

    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
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
<COMMENT><<EOF>>  {printf("Line %d, col %d: unterminated comment\n",auxL,auxC); BEGIN 0;}
{ELSE}            {if(flag==1)printf("ELSE\n");coluna+=yyleng;}
{WHILE}           {if(flag==1)printf("WHILE\n");coluna+=yyleng;}
{IF}              {if(flag==1)printf("IF\n");coluna+=yyleng;}
{CHAR}            {if(flag==1)printf("CHAR\n");coluna+=yyleng;}
{INT}             {if(flag==1)printf("INT\n");coluna+=yyleng;}
{SHORT}           {if(flag==1)printf("SHORT\n");coluna+=yyleng;}
{DOUBLE}          {if(flag==1)printf("DOUBLE\n");coluna+=yyleng;}
{RETURN}          {if(flag==1)printf("RETURN\n");coluna+=yyleng;}
{VOID}            {if(flag==1)printf("VOID\n");coluna+=yyleng;}
{BITWISEAND}      {if(flag==1)printf("BITWISEAND\n");coluna+=yyleng;}
{BITWISEOR}       {if(flag==1)printf("BITWISEOR\n");coluna+=yyleng;}
{BITWISEXOR}      {if(flag==1)printf("BITWISEXOR\n");coluna+=yyleng;}
{AND}             {if(flag==1)printf("AND\n");coluna+=yyleng;}
{ASSIGN}          {if(flag==1)printf("ASSIGN\n");coluna+=yyleng;}
{MUL}             {if(flag==1)printf("MUL\n");coluna+=yyleng;}
{COMMA}           {if(flag==1)printf("COMMA\n");coluna+=yyleng;}
{DIV}             {if(flag==1)printf("DIV\n");coluna+=yyleng;}
{EQ}              {if(flag==1)printf("EQ\n");coluna+=yyleng;}
{GE}              {if(flag==1)printf("GE\n");coluna+=yyleng;}
{GT}              {if(flag==1)printf("GT\n");coluna+=yyleng;}
{LBRACE}          {if(flag==1)printf("LBRACE\n");coluna+=yyleng;}
{LE}              {if(flag==1)printf("LE\n");coluna+=yyleng;}
{LPAR}            {if(flag==1)printf("LPAR\n");coluna+=yyleng;}
{LT}              {if(flag==1)printf("LT\n");coluna+=yyleng;}
{MINUS}           {if(flag==1)printf("MINUS\n");coluna+=yyleng;}
{MOD}             {if(flag==1)printf("MOD\n");coluna+=yyleng;}
{NE}              {if(flag==1)printf("NE\n");coluna+=yyleng;}
{NOT}             {if(flag==1)printf("NOT\n");coluna+=yyleng;}
{OR}              {if(flag==1)printf("OR\n");coluna+=yyleng;}
{PLUS}            {if(flag==1)printf("PLUS\n");coluna+=yyleng;}
{RBRACE}          {if(flag==1)printf("RBRACE\n");coluna+=yyleng;}
{RPAR}            {if(flag==1)printf("RPAR\n");coluna+=yyleng;}
{SEMI}            {if(flag==1)printf("SEMI\n");coluna+=yyleng;}
{RESERVED}        {if(flag==1)printf("RESERVED(%s)\n",yytext);coluna+=yyleng;}
{ID}              {if(flag==1)printf("ID(%s)\n",yytext);coluna+=yyleng;}
{INTLIT}          {if(flag==1)printf("INTLIT(%s)\n",yytext);coluna+=yyleng;}
{REALLIT}         {if(flag==1)printf("REALLIT(%s)\n",yytext);coluna+=yyleng;}
\'{CHRLIT}\'      {if(flag==1)printf("CHRLIT(%s)\n",yytext);coluna+=yyleng;}
\'([^\n\'\\]|\\.)*\'  {printf("Line %d, col %d: invalid char constant (%s)\n",linha,coluna,yytext);coluna+=yyleng;}
\'([^\n\'\\]|\\.)*(\\)?    {printf("Line %d, col %d: unterminated char constant\n",linha,coluna);coluna+=yyleng;}
{SPACE}           {coluna+=yyleng;}
\n|"\r\n"|"\r"    {linha++;coluna=1;}
.                 {printf("Line %d, col %d: illegal character (%s)\n",linha,coluna,yytext);coluna+=yyleng;}
%%

int main(int argc, char **argv)
{
    if (argc>1){
        if (argv[1][0]=='-' && argv[1][1]=='l'){
            flag=1;
        }
    }
    yylex();
    return 0;
}
int yywrap()
{
    return 1;
}
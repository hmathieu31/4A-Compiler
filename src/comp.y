%{
#include <stdlib.h>
#include <stdio.h>
int var[26];
void yyerror(char *s);
%}
%union { int nb; char var; }
%token tEGAL tOP tCP tSUB tADD tDIV tMUL tERROR tMAIN tCONST tINT tPRINT tOB tCOL tCB tSCOL
%token <nb> tNB
%token <var> tID
%type <nb> Expr
%start Code
%%
Code :  tMAIN tOB Ligne tCB;
Ligne : Expr tSCOL Ligne | Expr tSCOL;
Expr :  Def | Aff | Defaff | Ope | Print;
Def :   tCONST tINT tID
        |tINT tID;
Aff :   tID tEQ tNB;
Defaff :    Def tEQ tNB;
Ope :   Add | Sub | Mul | Div;      
Add :   Terme tADD Terme;
Sub :   Terme tSUB Terme;
Mul :   Terme tMUL Terme;
Div :   Terme tDIV Terme;


%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("Calculatrice\n"); // yydebug=1;
  yyparse();
  return 0;
}

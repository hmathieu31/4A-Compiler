%{
#include <stdlib.h>
#include <stdio.h>
int var[26];
void yyerror(char *s);
%}
%union { int nb; char var; }
%token tEQ tOP tCP tSUB tADD tDIV tMUL tMAIN tCONST tINT tPRINT tOB tCOL tCB tSCOL tERROR tIF tWHILE tEQUAL tNEQUAL tSUP tINF tEQSUP tEQINF tAND tOR
%token <nb> tNB
%token <var> tID
%type <nb> Expr
%start Code
%%
Code :  tMAIN Body;
Body : tOB Ligne tCB;
Ligne : Expr tSCOL Ligne 
        | Expr tSCOL
        |;
Expr :  Def 
        | Aff 
        | Defaff 
        | Ope 
        | Print
        |Fun
        |If
        |While;
Fun: tINT tID tOP Params tCP Body;
Params :Def tCOL Params
        |Def
        |;
If: tIF tOP Conds tCP Body;
While: tWHILE tOP Conds tCP Body;
Conds: Cond Conds
       |Cond;
Cond : Compa Logi Cond
       |Compa
       |Cond
       |tID
       |tNB;
Logi: tOR
      |tAND;
Def :   tCONST tINT tID
        |tINT tID
        |Def tCOL tID;
Aff :   tID tEQ Terme;
Defaff :    Def tEQ tNB;
Ope :   Add 
        | Sub 
        | Mul 
        | Div;      
Add :   Terme tADD Terme;
Sub :   Terme tSUB Terme;
Mul :   Terme tMUL Terme;
Div :   Terme tDIV Terme;

Compa : Eqsup | Eqinf | Sup | Inf | Equal | Nequal;
Eqsup : Terme tEQSUP Terme;
Eqinf : Terme tEQINF Terme;
Sup : Terme tSUP Terme;
Inf : Terme tINF Terme;
Equal : Terme tEQUAL Terme;
Nequal : Terme tNEQUAL Terme;

Terme : tOP Ope tCP
        | Ope
        | tID
        | tNB;
Print : tPRINT tOP tID tCP;



%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("Calculatrice\n"); // yydebug=1;
  yyparse();
  return 0;
}

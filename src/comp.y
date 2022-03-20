%{
#include <stdlib.h>
#include <stdio.h>

#include "symbolTable.h"
#include "instr.h"

int var[26];
void yyerror(char *s);
%}
%union { int nb; char *var; }
%token tEQ tOP tCP tSUB tADD tDIV tMUL tMAIN tCONST tINT tPRINT tOB tCOL tCB tSCOL tERROR tIF tWHILE tEQUAL tNEQUAL tSUP tINF tEQSUP tEQINF tAND tOR tRETURN
%token <nb> tNB
%token <var> tID
%type <nb> Expr
%start Code
%%
Code :  tMAIN 
                {initTable();}
         Body
        |Fun Code;
Body : tOB 
                {increaseDepth();} 
        Ligne tCB 
                {decreaseDepth();deleteFromChangeScope();}
        ;
FunBody : tOB Ligne Return tCB
        | tOB Return tCB;
Return : tRETURN Terme tSCOL;
Ligne : Instr tSCOL Ligne 
        |Instr tSCOL
        |;
Instr: Boucle
       |Expr;
Boucle: |If
        |While;
Expr : Dec 
        |Aff 
        |Defaff 
        |Ope 
        |Print;
Fun: tINT tID tOP Params tCP FunBody;
Params : Dec tCOL Params
        |Dec
        |;
InvokeFun: tID tOP Args tCP;
Args: Terme
        | Terme tCOL Args;
If: tIF tOP Conds tCP Body;
While: tWHILE tOP Conds tCP Body;
Conds: Cond Conds
       |Cond;
Cond: Compa Logi Cond
       |Compa
       |tID
       |tNB;
Logi: tOR
      |tAND;
Dec :   tCONST tINT tID 
                {
                        addSymbol($3, sizeof($3), t_int);
                        if(getAddressSymbol($3) != -1)
                        {
                                printf("Variable \"%s\" already exists. \n", $3);
                        }
                }
        |tINT tID 
                {
                        addSymbol($2, sizeof($2), t_int);
                        if(getAddressSymbol($2) != -1)
                        {
                                printf("Variable \"%s\" already exists. \n", $2);
                                exit(1);
                        }
                }
        |Dec tCOL tID
                {
                        addSymbol($3, sizeof($3), t_int);
                        if(getAddressSymbol($3) != -1)
                        {
                                printf("Variable \"%s\" already exists. \n", $3);
                                exit(1);
                        }
                };
Aff :   tID tEQ Terme
                {
                        if(getAddressSymbol($1) == -1) 
                        {
                                fprintf(stderr, "Variable \"%s\" is undefined.\n", $1);
                                exit(1);
                        } else {
                                int addrSymbol = getAddressSymbol($1); // WIP
                        }
                }  
        ;
Defaff : Dec tEQ Terme;
Ope :   Add 
        | Sub 
        | Mul 
        | Div;
Add :   Terme tADD Terme;
Sub :   Terme tSUB Terme;
Mul :   Terme tMUL Terme;
Div :   Terme tDIV Terme;

Compa : Eqsup 
        | Eqinf 
        | Sup 
        | Inf 
        | Equal 
        | Nequal;
Eqsup : Terme tEQSUP Terme;
Eqinf : Terme tEQINF Terme;
Sup : Terme tSUP Terme;
Inf : Terme tINF Terme;
Equal : Terme tEQUAL Terme;
Nequal : Terme tNEQUAL Terme;

Terme : tOP Ope tCP
        | Ope
        | tID
        | tNB
                {}
        | InvokeFun;
Print : tPRINT tOP tID tCP;



%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); exit(1);}
int main(void) {
  printf("Compiler\n"); // yydebug=1;
  yyparse();
  return 0;
}

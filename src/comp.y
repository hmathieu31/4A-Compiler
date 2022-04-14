%{
#include <stdlib.h>
#include <stdio.h>

#include "symbolTable.h"
#include "instr.h"
#include "macrologger.h"

void yyerror(char *s);
%}
%union { int nb; char *var; }
%token tEQ tOP tCP tSUB tADD tDIV tMUL tMAIN tCONST tINT tPRINT tOB tCOL tCB tSCOL tERROR tIF tWHILE tEQUAL tNEQUAL tSUP tINF tEQSUP tEQINF tAND tOR tRETURN
%token <nb> tNB
%token <var> tID
%type <nb> Terme Add Sub Mul Div Ope
%start Code
%%
Code :          {initTable(); initInstrArray();}  
        tMAIN Body
        |       {initTable(); initInstrArray();} 
        Fun Code;
Body : tOB 
                {increaseDepth();} 
        Ligne tCB 
                {decreaseDepth();deleteFromChangeScope();}
        ;
FunBody : tOB Ligne Return tCB
        | tOB Return tCB;
Return : tRETURN Terme tSCOL;
Ligne : Instr Ligne 
        |Instr
        |;
Instr: Boucle
       |Expr tSCOL;
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
Conds: Cond Conds //TODO: #6 Implement conditionals
       |Cond;
Cond: Compa Logi Cond
       |Compa
       |tID
       |tNB;
Logi: tOR
      |tAND;
Dec :   tCONST tINT tID 
                {
                        if(getAddressSymbol($3) != -1)
                        {
                                fprintf(stderr, "Variable \"%s\" already exists. \n", $3);
                                exit(1);
                        }
                        if(addSymbol($3, sizeof($3), t_int))
                        {
                                fprintf(stderr, "Symbol table full. Could not add variable \"%s\"", $3);
                                exit(1);
                        }
                }
        |tINT tID 
                {
                        if(getAddressSymbol($2) != -1)
                        {
                                fprintf(stderr, "Variable \"%s\" already exists. \n", $2);
                                exit(1);
                        }
                        if(addSymbol($2, sizeof($2), t_int))
                        {
                                fprintf(stderr, "Symbol table full. Could not add variable \"%s\"", $2);
                                exit(1);
                        }
                }
        |Dec tCOL tID
                {
                        if(getAddressSymbol($3) != -1)
                        {
                                fprintf(stderr, "Variable \"%s\" already exists. \n", $3);
                                exit(1);
                        }
                        if(addSymbol($3, sizeof($3), t_int))
                        {
                                fprintf(stderr, "Symbol table full. Could not add variable \"%s\"", $3);
                                exit(1);

                        }
                };
Aff :   tID tEQ Terme
                {
                        int addrSymbol = getAddressSymbol($1);
                        if(addrSymbol == -1) 
                        {
                                fprintf(stderr, "Variable \"%s\" is undefined.\n", $1);
                                exit(1);
                        }
                        instruction instr = {
                                COP,
                                {addrSymbol, $3, -1}
                        };
                        if(addInstruction(instr))
                        {
                                fprintf(stderr, "Failed to add instruction.\n");
                                exit(1);
                        }
                        freeAddrsTemp();
                }
        ;
Defaff : tCONST tINT tID tEQ Terme
                {
                        int addrSymbol = getAddressSymbol($3);
                        if(addrSymbol != -1)
                        {
                                fprintf(stderr, "Variable \"%s\" already exists. \n", $3);
                                exit(1);
                        }
                        if(addSymbol($3, sizeof($3), t_int))
                        {
                                fprintf(stderr, "Symbol table full. Could not add variable \"%s\"", $3);
                                exit(1);
                        }
                        instruction instr = {COP, {addrSymbol, $5, -1}};
                        if(addInstruction(instr))
                        {
                                fprintf(stderr, "Failed to add instruction.\n");
                                exit(1);
                        }
                        freeAddrsTemp();
                }
        |tINT tID tEQ Terme
                {
                        int addrSymbol = getAddressSymbol($2);
                        if(addrSymbol != -1)
                        {
                                fprintf(stderr, "Variable \"%s\" already exists. \n", $2);
                                exit(1);
                        }
                        if(addSymbol($2, sizeof($2), t_int))
                        {
                                fprintf(stderr, "Symbol table full. Could not add variable \"%s\"", $2);
                                exit(1);
                        }
                        instruction instr = {COP, {addrSymbol, $4, -1}};
                        if(addInstruction(instr))
                        {
                                fprintf(stderr, "Failed to add instruction.\n");
                                exit(1);
                        }
                        freeAddrsTemp();
                }
                ;
Ope :   Add     // TODO: #7 Handle priorities in operations
                {$$ = $1;}
        | Sub 
                {$$ = $1;}
        | Mul 
                {$$ = $1;}
        | Div
                {$$ = $1;};
Add :   Terme tADD Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}};     // Affect the first operand to a temporary var
                if(addInstruction(instr))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {ADD, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                $$ = temp3;
        }        
        ;
Sub :   Terme tSUB Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {SUB, {temp3, temp1, temp2}};       // Substract the two temporary vars with the result being in temp3
                if(addInstruction(instr3))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                $$ = temp3;
        }        
        ;
Mul :   Terme tMUL Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {MUL, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                $$ = temp3;
        }        
        ;
Div :   Terme tDIV Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {DIV, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3))
                {
                        fprintf(stderr, "Failed to add instruction.\n");
                        exit(1);
                }
                $$ = temp3;
        }        
        ;

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
                {$$ = $2;}
        | Ope
                {$$ = $1;}
        | tID
                {$$ = getAddressSymbol($1);}
        | tNB
                {
                        int addrTemp =newTmp();
                        instruction instr = {AFC, {addrTemp, $1, -1}};
                        if(addInstruction(instr))
                        {
                                fprintf(stderr, "Failed to add instruction.\n");
                                exit(1);
                        }
                        $$ = addrTemp;
                }
        | InvokeFun;
Print : tPRINT tOP tID tCP;



%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); exit(1);}
int main(void) {

  printf("Compiler\n"); // yydebug=1;
  yyparse();

  printf("--- Table des instructions ---\n");
  printInstrTable();
  return 0;
}

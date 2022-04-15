%{
#include <stdlib.h>
#include <stdio.h>

#include "symbolTable.h"
#include "instr.h"
#include "macrologger.h"

void yyerror(char *s);
%}
%union { int nb; char *var; }
%token tEQ tOP tCP tSUB tADD tDIV tMUL tMAIN tCONST tINT tPRINT tOB tCOL tCB tSCOL tERROR tEQUAL tNEQUAL tSUP tINF tEQSUP tEQINF tAND tOR tRETURN tELSE
%right tEQ
%left tEQUAL tNEQUAL tSUP tINF tEQSUP tEQINF
%left tADD tSUB
%left tMUL tDIV
%token <nb> tNB tIF tWHILE
%token <var> tID
%type <nb> Terme Add Sub Mul Div Ope Eqinf Eqsup Sup Inf Equal Nequal Cond And Or
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
Boucle: If
        /* |Ifel */
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
If: tIF tOP Terme tCP
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}};
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {AFC, 0, -1}};
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {EQUAL, {temp3, temp1, temp2}};
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                instruction instrJMPF = {JMF, {temp3, -1, -1}};
                int line = addInstruction(instrJMPF);
                if(line == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instrJMPF));
                        exit(1);
                }
                $1 = line;
        }
        Body
        {
                int currentLine = getNumberOfInstructions();
                patchJmpInstruction($1, currentLine + 1);
        };
/* Ifel: tIF tOP Terme tCP 
        {
                        int temp1 = newTmp();
                        instruction instr = {COP, {temp1, $1, -1}};
                        if(addInstruction(instr) == -1)
                        {
                                fprintf(stderr, "Failed to add instruction.\n");
                                exit(1);
                        }
                        int temp2 = newTmp();
                        instruction instr2 = {COP, {AFC, 0, -1}};
                        if(addInstruction(instr2) == -1)
                        {
                                fprintf(stderr, "Failed to add instruction.\n");
                                exit(1);
                        }
                        int temp3 = newTmp();
                        instruction instr3 = {EQUAL, {temp3, temp1, temp2}};
                        if(addInstruction(instr3) == -1)
                        {
                                fprintf(stderr, "Failed to add instruction.\n");
                                exit(1);
                        }
                        instruction instrJMPF = {JMF, {temp3, -1, -1}};
                        int line = addInstruction(instrJMPF);
                        if(line == -1)
                        {
                                fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instrJMPF));
                                exit(1);
                        }
                        $1 = line;
        }
        Body
        {
                        int currentLigne = getNumberOfInstructions();
                        patchJmpInstruction($1, currentLigne + 2);
                        instruction instr = {JMP, {-1, -1, -1}};
                        int line = addInstruction(instr);
                        if(line == -1)
                        {
                                fprintf(stderr, "Failed to add instruction.\n");
                                exit(1);
                        }
                        $1 = line;
        }
        tELSE 
        Body
        {
                        int current = getNumberOfInstructions();
                        patchJmpInstruction($1, current + 1);
        }; */
While: tWHILE tOP Cond tCP
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}};
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {AFC, 0, -1}};
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {EQUAL, {temp3, temp1, temp2}};
                int line = addInstruction(instr3);
                if(line == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                instruction instrJMPF = {JMF, {temp3, -1, -1}};
                if(addInstruction(instrJMPF) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instrJMPF));
                        exit(1);
                }
                $1 = line;
        }
        Body
                {
                int currentLine = getNumberOfInstructions();
                patchJmpInstruction($1, currentLine + 2);
                instruction instrJMP = {JMP, {$1, -1, -1}};
                if(addInstruction(instrJMP) == -1) {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instrJMP));
                        exit(1);
                }
        };
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
                        if(addInstruction(instr) == -1)
                        {
                                fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
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
                        addrSymbol = getAddressSymbol($3);
                        instruction instr = {COP, {addrSymbol, $5, -1}};
                        if(addInstruction(instr) == -1)
                        {
                                fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
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
                        addrSymbol = getAddressSymbol($2);
                        instruction instr = {COP, {addrSymbol, $4, -1}};
                        if(addInstruction(instr) == -1)
                        {
                                fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
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
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {ADD, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        }        
        ;
Sub :   Terme tSUB Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {SUB, {temp3, temp1, temp2}};       // Substract the two temporary vars with the result being in temp3
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        }        
        ;
Mul :   Terme tMUL Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {MUL, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        }        
        ;
Div :   Terme tDIV Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {DIV, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        }        
        ;

Cond : Eqsup
        {$$ = $1;}
        | Eqinf 
        {$$ = $1;}
        | Sup 
        {$$ = $1;}
        | Inf 
        {$$ = $1;}
        | Equal 
        {$$ = $1;}
        | Nequal
        {$$ = $1;}
        | Or
        {$$ = $1;}
        | And
        {$$ = $1;}
Eqsup : Terme tEQSUP Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {EQSUP, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        };
Eqinf : Terme tEQINF Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {EQINF, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        };
Sup : Terme tSUP Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {SUP, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        };
Inf : Terme tINF Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {INF, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        };
Equal : Terme tEQUAL Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {EQUAL, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        };
Nequal : Terme tNEQUAL Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {NEQUAL, {temp3, temp1, temp2}};       // Add the two temporary vars with the result being in temp3
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        }
Or: Terme tOR Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {OR, {temp3, temp1, temp2}};
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        };
And: Terme tAND Terme
        {
                int temp1 = newTmp();
                instruction instr = {COP, {temp1, $1, -1}}; // Affect the first operand to a temporary var
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp2 = newTmp();
                instruction instr2 = {COP, {temp2, $3, -1}};       // Affect the second operand to a temporary var
                if(addInstruction(instr2) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr2));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {AND, {temp3, temp1, temp2}};
                if(addInstruction(instr3) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr3));
                        exit(1);
                }
                $$ = temp3;
        };


Terme : tOP Ope tCP
                {$$ = $2;}
        | Ope
                {$$ = $1;}
        | tOP Cond tCP
                {$$ = $2;}
        | Cond
                {$$ = $1;}
        | tID
                {$$ = getAddressSymbol($1);}
        | tNB
                {
                        int addrTemp =newTmp();
                        instruction instr = {AFC, {addrTemp, $1, -1}};
                        if(addInstruction(instr) == -1)
                        {
                                fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                                exit(1);
                        }
                        $$ = addrTemp;
                }
        | InvokeFun;
Print : tPRINT tOP tID tCP
        {
                int addrSymbol = getAddressSymbol($3);
                if(addrSymbol == -1) 
                {
                        fprintf(stderr, "Failed to get address of symbol \"%s\".\n", $3);
                        exit(1);
                }
                instruction instr = {PRI, {addrSymbol, -1, -1}};
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
        }
;

%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); exit(1);}
int main(void) {

  printf("Compiler\n"); // yydebug=1;
  yyparse();

  /* printf("--- Table des instructions ---\n"); */
  /* printInstrTable(); */

  // Apply interpreter
  printf("--- Interpret code ---\n");
  interpret();  
  return 0;
}

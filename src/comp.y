%{
#include <stdlib.h>
#include <stdio.h>

#include "symbolTable.h"
#include "instr.h"
#include "macrologger.h"
#include "interpreter.h"

void yyerror(char *s);
%}
%union { int nb; char *var; }
%token tEQ tCP tSUB tADD tDIV tMUL tMAIN tCONST tINT tPRINT tOB tCOL tCB tSCOL tERROR tEQUAL tNEQUAL tSUP tINF tEQSUP tEQINF tAND tOR tRETURN tELSE
%right tEQ
%left tEQUAL tNEQUAL tSUP tINF tEQSUP tEQINF
%left tADD tSUB
%left tMUL tDIV
%token <nb> tNB tIF tWHILE tOP
%token <var> tID
%type <nb> Terme Add Sub Mul Div Ope Eqinf Eqsup Sup Inf Equal Nequal Cond And Or InvokeFun
%start Program
%%
Program: {initTable(); initInstrArray(); initFunctionTable();} Code;
Code : Main | Fun Code;
Main: tMAIN
        {
                resetFunctionDepth();
                instruction instr = {ENTRY, {1, 1, 1}};
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Error : could not add entry point\n");
                        exit(1);
                }
        } Body;
Body : tOB 
                {increaseDepth();} 
        Ligne tCB 
                {decreaseDepth();deleteFromChangeScope();}
        ;
FunBody : tOB
        Ligne Return tCB {decreaseDepth();}
        | tOB Return tCB {decreaseDepth();}
        ;
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
Fun: tINT tID 
        {
                if(getFunctionAddress($2) != -1)
                {
                        fprintf(stderr ,"Error : function %s already defined\n", $2);
                        exit(1);
                }
                int line = getNumberOfInstructions();
                if(addFunction($2, line) == -1)
                {
                        fprintf(stderr, "Error : Function table is full\n");
                        exit(1);
                }
        }
        tOP {increaseFunctionDepth();} Params tCP {increaseDepth();} FunBody
        {
                instruction instr = {JMP, {-1}};
                int line = addInstruction(instr);
                if(line == -1)
                {
                        fprintf(stderr, "Error : Instruction table is full\n");
                        exit(1);
                }
                if(setFunctionReturnAddress($2, line) == -1)
                {
                        fprintf(stderr, "Error : Function %s not found\n", $2);
                        exit(1);
                }
        }
        ;
Params : Dec tCOL Params
        |Dec
        |;
InvokeFun: tID tOP Args tCP
        {
                if(setFunctionScope($1) == -1)
                {
                        fprintf(stderr, "Error : Function %s not defined\n", $1);
                        exit(1);
                }
                int argAddr = getNextArgumentAddress();
                int i = 1;
                while(argAddr != -1)
                {
                        int paramAddr = getFunctionParameterAddress($1, i);
                        instruction instr = {COP, {paramAddr, argAddr, -1}};
                        if(addInstruction(instr) == -1)
                        {
                                fprintf(stderr, "Error : Instruction table is full\n");
                                exit(1);
                        }
                        argAddr = getNextArgumentAddress();
                        i++;
                }
                int currentLine = getNumberOfInstructions();
                if(currentLine == -1)
                {
                        fprintf(stderr, "Error : Instruction table is empty\n");
                        exit(1);
                }
                patchJmpInstruction(getFunctionReturnAddress($1), currentLine + 1);
                instruction instr = {JMP, {getFunctionAddress($1)}};
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Error : Instruction table is full\n");
                        exit(1);
                }
                // TODO: #37 Handle the return variable issue
        }
        ;
Args: Terme
        {
                int argAddr = addArgument();
                instruction instr = {AFC, {argAddr, $1, -1}};
                addInstruction(instr);
        }
        | Terme
        {
                int argAddr = addArgument();
                instruction instr = {AFC, {argAddr, $1, -1}};
                addInstruction(instr);
        } tCOL Args
        |;
If: tIF tOP
        {$2 = getNumberOfInstructions();}
        Terme tCP
        {
                int temp1 = newTmp();
                instruction instr1 = {AFC, {temp1, 1, -1}};
                if(addInstruction(instr1) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr1));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {EQUAL, {temp3, $4, temp1}};
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
                patchJmpInstruction($1, currentLine - 1);
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
While: tWHILE tOP 
        {$2 = getNumberOfInstructions();}
        Cond tCP      // TODO: #27 Debug While
        {
                int temp = newTmp();
                instruction instr = {AFC, {temp, 1, -1}};
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                int temp3 = newTmp();
                instruction instr3 = {EQUAL, {temp3, $4, temp}};
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
                instruction instrJMP = {JMP, {$2 - 1, -1, -1}};
                if(addInstruction(instrJMP) == -1) {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instrJMP));
                        exit(1);
                }
                int currentLine = getNumberOfInstructions();
                patchJmpInstruction($1, currentLine);
        };
Dec :   tCONST tINT tID 
                {
                        if(getSymbolAddress($3) != -1)
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
                        if(getSymbolAddress($2) != -1)
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
                        if(getSymbolAddress($3) != -1)
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
                        int addrSymbol = getSymbolAddress($1);
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
                        int addrSymbol = getSymbolAddress($3);
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
                        addrSymbol = getSymbolAddress($3);
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
                        int addrSymbol = getSymbolAddress($2);
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
                        addrSymbol = getSymbolAddress($2);
                        instruction instr = {COP, {addrSymbol, $4, -1}};
                        if(addInstruction(instr) == -1)
                        {
                                fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                                exit(1);
                        }
                        freeAddrsTemp();
                }
                ;
Ope :   Add
                {$$ = $1;}
        | Sub 
                {$$ = $1;}
        | Mul 
                {$$ = $1;}
        | Div
                {$$ = $1;};
Add :   Terme tADD Terme
        {
                int temp = newTmp();
                instruction instr = {ADD, {temp, $1, $3}};       // Add the two terms with the result being in temp3
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
        }        
        ;
Sub :   Terme tSUB Terme
        {
                int temp = newTmp();
                instruction instr = {SUB, {temp, $1, $3}};       // Substract the two temporary vars with the result being in temp
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
        }        
        ;
Mul :   Terme tMUL Terme
        {
                int temp = newTmp();
                instruction instr = {MUL, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
        }        
        ;
Div :   Terme tDIV Terme
        {
                int temp = newTmp();
                instruction instr = {DIV, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
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
                int temp = newTmp();
                instruction instr = {EQSUP, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
        };
Eqinf : Terme tEQINF Terme
        {
                int temp = newTmp();
                instruction instr = {EQINF, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
        };
Sup : Terme tSUP Terme
        {
                int temp = newTmp();
                instruction instr = {SUP, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
        };
Inf : Terme tINF Terme
        {
                int temp = newTmp();
                instruction instr = {INF, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
        };
Equal : Terme tEQUAL Terme
        {
                int temp = newTmp();
                instruction instr = {EQUAL, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
        };
Nequal : Terme tNEQUAL Terme
        {
                int temp = newTmp();
                instruction instr = {NEQUAL, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
        }
Or: Terme tOR Terme
        {
                int temp = newTmp();
                instruction instr = {OR, {temp, $1, $3}};
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
        };
And: Terme tAND Terme
        {
                int temp = newTmp();
                instruction instr = {AND, {temp, $1, $3}};
                if(addInstruction(instr) == -1)
                {
                        fprintf(stderr, "Failed to add instruction \"%s\".\n", stringOfInstruction(instr));
                        exit(1);
                }
                $$ = temp;
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
                {$$ = getSymbolAddress($1);}
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
        | InvokeFun
                {$$ = $1;}
        ;
Print : tPRINT tOP tID tCP
        {
                int addrSymbol = getSymbolAddress($3);
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

/*   printf("--- Table des instructions ---\n");
  printInstrTable(); */

  // Apply interpreter
  printf("--- Interpret code ---\n");
  interpret();  
  return 0;
}

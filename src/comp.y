%{
#include <stdlib.h>
#include <stdio.h>

#include "symbolTable.h"
#include "instr.h"
#include "macrologger.h"
#include "interpreter.h"

extern FILE *yyin;
extern int yylineno;
int error_count = 0;
char err[100];

void yyerror(const char *s);
%}
%define parse.error detailed
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
			sprintf(err, "Error : could not add entry point");
			yyerror(err);
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
Return : tRETURN Terme tSCOL
	{
		int returnVar = addSymbol("_ret", sizeof("_ret"), t_int);
		if(returnVar == -1)
		{
			sprintf(err, "Could not add return variable");
			yyerror(err);
		}

		instruction instr = {COP, {returnVar, $2, -1}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Line %d | Could not add %s instruction", yylineno ,stringOfInstruction(instr));
			yyerror(err);
		}
		setFunctionReturnVarAddress(returnVar);

	}
;
Ligne : Instr Ligne
	|Instr
	|;
Instr: Boucle
	   |Expr tSCOL
	   |error tSCOL
	   ;
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
			yyerror(err);
		}
		int line = getNumberOfInstructions();
        increaseFunctionDepth();
		if(addFunction($2, line) == -1)
		{
			sprintf(err, "Error : could not add function %s", $2);
			yyerror(err);
		}
	}
	tOP Params tCP {increaseDepth();} FunBody
	{
		instruction instr = {JMP, {-2, -1, -1}};
		int line = addInstruction(instr);
		if(line == -1)
		{
			sprintf(err, "Error : Instruction table is full");
			yyerror(err);
		}
		if(setFunctionReturnAddress($2, line) == -1)
		{
			sprintf(err, "Error : Function %s not found", $2);
			yyerror(err);
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
			sprintf(err, "Error : Function %s not defined", $1);
			yyerror(err);
		}
		int argAddr = getNextArgumentAddress();
		int i = 1;
		while(argAddr != -1)
		{
			int paramAddr = getFunctionParameterAddress($1, i);
            if(paramAddr == -1)
            {
                sprintf(err, "Error : Function %s is undefined", $1);
                yyerror(err);
            }
            if(paramAddr == -2)
            {
                sprintf(err, "Error : Function %s has no argument %d", $1, i);
                yyerror(err);
            }
			instruction instr = {COP, {paramAddr, argAddr, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Error : Instruction table is full");
				yyerror(err);
			}
			argAddr = getNextArgumentAddress();
			i++;
		}
		int currentLine = getNumberOfInstructions();
		if(currentLine == -1)
		{
			sprintf(err, "Error : Instruction table is empty");
			yyerror(err);
		}
		patchJmpInstruction(getFunctionReturnAddress($1), currentLine + 1, JMP);
		instruction instr = {JMP, {getFunctionAddress($1), -1, -1}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Error : Instruction table is full");
			yyerror(err);
		}
		resetFunctionDepth();
		int returnVar = getFunctionReturnVarAddress($1);
		if(returnVar == -1)
		{
			sprintf(err, "No return variable found");
			yyerror(err);
		}
		$$ = returnVar;
	}
	;
Args: Terme
	{
		int argAddr = addArgument();
        if(argAddr == -1)
        {
            sprintf(err, "Error : Memory space allocated to arguments overflowed");
            yyerror(err);
        }
		instruction instr = {COP, {argAddr, $1, -1}};
		addInstruction(instr);
	}
	| Terme
	{
		int argAddr = addArgument();
        if(argAddr == -1)
        {
            sprintf(err, "Error : Memory space allocated to arguments overflowed");
            yyerror(err);
        }
		instruction instr = {COP, {argAddr, $1, -1}};
		addInstruction(instr);
	} tCOL Args
	|;
If: tIF tOP
	{$2 = getNumberOfInstructions();}
	Terme tCP
	{
		int temp1 = newTmp();
        if(temp1 == -1)
        {
            sprintf(err, "Error : Instruction table is full");
            yyerror(err);
        }
		instruction instr1 = {AFC, {temp1, 1, -1}};
		if(addInstruction(instr1) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr1));
			yyerror(err);
		}
		int temp3 = newTmp();
        if(temp3 == -1)
        {
            sprintf(err, "Error : Instruction table is full");
            yyerror(err);
        }
		instruction instr3 = {EQUAL, {temp3, $4, temp1}};
		if(addInstruction(instr3) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr3));
			yyerror(err);
		}
		instruction instrJMPF = {JMF, {temp3, -1, -1}};
		int line = addInstruction(instrJMPF);
		if(line == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instrJMPF));
			yyerror(err);
		}
		$1 = line;
	}
	Body
	{
		int currentLine = getNumberOfInstructions();
		patchJmpInstruction($1, currentLine, JMF);
	};
/* Ifel: tIF tOP Terme tCP
	{
			int temp1 = newTmp();
            if(temp1 == -1)
            {
                sprintf(err, "Error : Instruction table is full");
                yyerror(err);
            }
			instruction instr = {COP, {temp1, $1, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Failed to add instruction.");
				yyerror(err);
			}
			int temp2 = newTmp();
			instruction instr2 = {COP, {AFC, 0, -1}};
			if(addInstruction(instr2) == -1)
			{
				sprintf(err, "Failed to add instruction.");
				yyerror(err);
			}
			int temp3 = newTmp();
			instruction instr3 = {EQUAL, {temp3, temp1, temp2}};
			if(addInstruction(instr3) == -1)
			{
				sprintf(err, "Failed to add instruction.");
				yyerror(err);
			}
			instruction instrJMPF = {JMF, {temp3, -1, -1}};
			int line = addInstruction(instrJMPF);
			if(line == -1)
			{
				sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instrJMPF));
				yyerror(err);
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
				sprintf(err, "Failed to add instruction.");
				yyerror(err);
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
        if(temp == -1)
        {
            sprintf(err, "Error : Instruction table is full");
            yyerror(err);
        }
		instruction instr = {AFC, {temp, 1, -1}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		int temp3 = newTmp();
        if(temp3 == -1)
        {
            sprintf(err, "Error : Instruction table is full");
            yyerror(err);
        }
		instruction instr3 = {EQUAL, {temp3, $4, temp}};
		if(addInstruction(instr3) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr3));
			yyerror(err);
		}
		instruction instrJMPF = {JMF, {temp3, -2, -1}};
		int line = addInstruction(instrJMPF);
		if(line == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instrJMPF));
			yyerror(err);
		}
		$1 = line;
	}
	Body
		{
		instruction instrJMP = {JMP, {$2, -1, -1}};
		if(addInstruction(instrJMP) == -1) {
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instrJMP));
			yyerror(err);
		}
		int currentLine = getNumberOfInstructions();
		patchJmpInstruction($1, currentLine, JMF);
	};
Dec :   tCONST tINT tID
		{
			if(getSymbolAddress($3) != -1)
			{
				sprintf(err, "Variable \"%s\" already exists. ", $3);
				yyerror(err);
			}
			if(addSymbol($3, sizeof($3), t_int) == -1)
			{
				sprintf(err, "Symbol table full. Could not add variable \"%s\"", $3);
				yyerror(err);
			}
		}
	|tINT tID
		{
			if(getSymbolAddress($2) != -1)
			{
				sprintf(err, "Variable \"%s\" already exists. ", $2);
				yyerror(err);
			}
			if(addSymbol($2, sizeof($2), t_int) == -1)
			{
				sprintf(err, "Symbol table full. Could not add variable \"%s\"", $2);
				yyerror(err);
			}
		}
	|Dec tCOL tID
		{
			if(getSymbolAddress($3) != -1)
			{
				sprintf(err, "Variable \"%s\" already exists. ", $3);
				yyerror(err);
			}
			if(addSymbol($3, sizeof($3), t_int) == -1)
			{
				sprintf(err, "Symbol table full. Could not add variable \"%s\"", $3);
				yyerror(err);

			}
		};
Aff :   tID tEQ Terme
		{
			int addrSymbol = getSymbolAddress($1);
			if(addrSymbol == -1)
			{
				sprintf(err, "Variable \"%s\" is undefined.", $1);
				yyerror(err);
			}
			instruction instr = {
				COP,
				{addrSymbol, $3, -1}
			};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
				yyerror(err);
			}
			freeAddrsTemp();
		}
	;
Defaff : tCONST tINT tID tEQ Terme
		{
			int addrSymbol = getSymbolAddress($3);
			if(addrSymbol != -1)
			{
				sprintf(err, "Variable \"%s\" already exists. ", $3);
				yyerror(err);
			}
			if(addSymbol($3, sizeof($3), t_int) == -1)
			{
				sprintf(err, "Symbol table full. Could not add variable \"%s\"", $3);
				yyerror(err);
			}
			addrSymbol = getSymbolAddress($3);
			instruction instr = {COP, {addrSymbol, $5, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
				yyerror(err);
			}
			freeAddrsTemp();
		}
	|tINT tID tEQ Terme
		{
			int addrSymbol = getSymbolAddress($2);
			if(addrSymbol != -1)
			{
				sprintf(err, "Variable \"%s\" already exists. ", $2);
				yyerror(err);
			}
			if(addSymbol($2, sizeof($2), t_int) == -1)
			{
				sprintf(err, "Symbol table full. Could not add variable \"%s\"", $2);
				yyerror(err);
			}
			addrSymbol = getSymbolAddress($2);
			instruction instr = {COP, {addrSymbol, $4, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
				yyerror(err);
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
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {ADD, {temp, $1, $3}};       // Add the two terms with the result being in temp3
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		$$ = temp;
	}
	;
Sub :   Terme tSUB Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {SUB, {temp, $1, $3}};       // Substract the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		$$ = temp;
	}
	;
Mul :   Terme tMUL Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {MUL, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		$$ = temp;
	}
	;
Div :   Terme tDIV Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {DIV, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
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
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {EQSUP, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		$$ = temp;
	};
Eqinf : Terme tEQINF Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {EQINF, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		$$ = temp;
	};
Sup : Terme tSUP Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {SUP, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		$$ = temp;
	};
Inf : Terme tINF Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {INF, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		$$ = temp;
	};
Equal : Terme tEQUAL Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {EQUAL, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		$$ = temp;
	};
Nequal : Terme tNEQUAL Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {NEQUAL, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		$$ = temp;
	}
Or: Terme tOR Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {OR, {temp, $1, $3}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
		$$ = temp;
	};
And: Terme tAND Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Failed to create temporary variable.");
            yyerror(err);
        }
		instruction instr = {AND, {temp, $1, $3}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
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
            if(addrTemp == -1)
            {
                sprintf(err, "Failed to create temporary variable.");
                yyerror(err);
            }
			instruction instr = {AFC, {addrTemp, $1, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
				yyerror(err);
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
			sprintf(err, "Failed to get address of symbol \"%s\".", $3);
			yyerror(err);
		}
		instruction instr = {PRI, {addrSymbol, -1, -1}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Failed to add instruction \"%s\".", stringOfInstruction(instr));
			yyerror(err);
		}
	}
;

%%
void yyerror(const char *s) { 
	fprintf(stderr, "ERROR | Line %d | %s\n", yylineno, s);
	error_count++;
}

int main(int argc, char **argv) {
	if(argc != 2) {
		fprintf(stderr, "Usage: %s <input file>\n", argv[0]);
		exit(1);
	}
	FILE *f = fopen(argv[1], "r");
	if(f == NULL) {
		fprintf(stderr, "Failed to open file \"%s\".\n", argv[1]);
		exit(1);
	}
	yyin = f;
	yyparse();
	if(error_count > 0) {
		fprintf(stderr, "  ERROR -- Compilation failed. --  \n");
		fclose(f);
		return 1;
	}
    /* printInstrTable(); */
    interpret();
	fclose(f);
	return 0;
}

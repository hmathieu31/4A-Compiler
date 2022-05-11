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
Program: {initTable(); initInstrArray(); initFunctionTable(); initScopesStack();} Code;
Code : Main | Fun Code;
Main: tMAIN
	{
		resetFunctionScope();
		instruction instr = {ENTRY, {1, 1, 1}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
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
Return : tRETURN Terme tSCOL
	{
		int returnVar = addSymbol("_ret", sizeof("_ret"), t_int);
		if(returnVar == -1)
		{
			sprintf(err, "Symbol table is full");
			yyerror(err);
		}

		instruction instr = {COP, {returnVar, $2, -1}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
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
	|InvokeFun
	|Print;
Fun: tINT tID
	{
		if(getFunctionAddress($2) != -1)
		{
			fprintf(stderr ,"Function %s already defined\n", $2);
			yyerror(err);
		}
		int line = getNumberOfInstructions();
        increaseFunctionDepth();
		setFunctionScope($2);
		if(addFunction($2, line) == -1)
		{
			sprintf(err, "Could not add function %s, function table is full", $2);
			yyerror(err);
			exit(1);
		}
	}
	tOP Params tCP {increaseDepth();} FunBody
	{
		instruction instr = {JMX, {FUNCTION_JMP_ADDR, -1, -1}};
		int line = addInstruction(instr);
		if(line == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		if(setFunctionReturnAddress($2, line) == -1)
		{
			sprintf(err, "Function '%s' undefined", $2);
			yyerror(err);
		}
	}
	;
Params : Dec tCOL Params
	|Dec
	|;
InvokeFun: tID tOP Args tCP
	{
		int error_state = 0;
		if(setFunctionScope($1) == -1)
		{
			sprintf(err, "Function '%s' undefined", $1);
			yyerror(err);
			error_state = 1;
		}
		int argAddr = getNextArgumentAddress();
		int i = 1;
		while(argAddr != -1 && !error_state)
		{
			int paramAddr = getFunctionParameterAddress($1, i);
            if(paramAddr == -1)
            {
                sprintf(err, "Function '%s' is undefined", $1);
                yyerror(err);
            }
            if(paramAddr == -2)
            {
                sprintf(err, "Too many arguments for function '%s'", $1);
                yyerror(err);
				error_state = 1;
            }
			instruction instr = {COP, {paramAddr, argAddr, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Instruction table is full");
				yyerror(err);
				exit(1);
			}
			argAddr = getNextArgumentAddress();
			i++;
		}
		if (!error_state)
		{
			int currentLine = getNumberOfInstructions();
			if(currentLine == -1)
			{
				sprintf(err, "Instruction table is empty");
				yyerror(err);
			}
			instruction instr = {AFC, {FUNCTION_JMP_ADDR, currentLine + 2, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Instruction table is full");
				yyerror(err);
				exit(1);
			}
			instruction instr1 = {JMP, {getFunctionAddress($1), -1, -1}};
			if(addInstruction(instr1) == -1)
			{
				sprintf(err, "Instruction table is full");
				yyerror(err);
				exit(1);
			}
			resetFunctionScope();
			int returnVar = getFunctionReturnVarAddress($1);
			if(returnVar == -1)
			{
				sprintf(err, "No return variable found");
				yyerror(err);
			}
			$$ = returnVar;
		}
	}
	;
Args: Terme
	{
		int argAddr = addArgument();
        if(argAddr == -1)
        {
            sprintf(err, "Memory space allocated to arguments exhausted");
            yyerror(err);
			exit(1);
        }
		instruction instr = {COP, {argAddr, $1, -1}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
	}
	| Terme
	{
		int argAddr = addArgument();
        if(argAddr == -1)
        {
            sprintf(err, "Memory space allocated to arguments exhausted");
            yyerror(err);
			exit(1);
        }
		instruction instr = {COP, {argAddr, $1, -1}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
	} tCOL Args
	|;
If: tIF tOP
	{$2 = getNumberOfInstructions();}
	Terme tCP
	{
		int temp1 = newTmp();
        if(temp1 == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables exhausted");
            yyerror(err);
			exit(1);
        }
		instruction instr1 = {AFC, {temp1, 1, -1}};
		if(addInstruction(instr1) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		int temp3 = newTmp();
        if(temp3 == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables exhausted");
            yyerror(err);
			exit(1);
        }
		instruction instr3 = {EQUAL, {temp3, $4, temp1}};
		if(addInstruction(instr3) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		instruction instrJMPF = {JMF, {temp3, -1, -1}};
		int line = addInstruction(instrJMPF);
		if(line == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
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
                sprintf(err, "Instruction table is full");
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
	Cond tCP
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables exhausted");
            yyerror(err);
			exit(1);
        }
		instruction instr = {AFC, {temp, 1, -1}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		int temp3 = newTmp();
        if(temp3 == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables exhausted");
            yyerror(err);
			exit(1);
        }
		instruction instr3 = {EQUAL, {temp3, $4, temp}};
		if(addInstruction(instr3) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		instruction instrJMPF = {JMF, {temp3, -2, -1}};
		int line = addInstruction(instrJMPF);
		if(line == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		$1 = line;
	}
	Body
		{
		instruction instrJMP = {JMP, {$2, -1, -1}};
		if(addInstruction(instrJMP) == -1) {
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
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
				sprintf(err, "Symbol table full.");
				yyerror(err);
				exit(1);
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
				sprintf(err, "Symbol table full.");
				yyerror(err);
				exit(1);
			}
		}
	|Dec tCOL tID
		{
			if(getSymbolAddress($3) != -1)
			{
				sprintf(err, "Variable \"%s\" already exists.", $3);
				yyerror(err);
			}
			if(addSymbol($3, sizeof($3), t_int) == -1)
			{
				sprintf(err, "Symbol table full.");
				yyerror(err);
				exit(1);
			}
		};
Aff :   tID tEQ Terme
		{
			int addrSymbol = getSymbolAddress($1);
			if(addrSymbol == -1)
			{
				sprintf(err, "Variable \"%s\" undefined.", $1);
				yyerror(err);
			}
			instruction instr = {
				COP,
				{addrSymbol, $3, -1}
			};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Instruction table is full.");
				yyerror(err);
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
				sprintf(err, "Variable \"%s\" already exists. ", $3);
				yyerror(err);
			}
			if(addSymbol($3, sizeof($3), t_int) == -1)
			{
				sprintf(err, "Symbol table full.");
				yyerror(err);
				exit(1);
			}
			addrSymbol = getSymbolAddress($3);
			instruction instr = {COP, {addrSymbol, $5, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Instruction table is full.");
				yyerror(err);
				exit(1);
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
				sprintf(err, "Symbol table full.");
				yyerror(err);
				exit(1);
			}
			addrSymbol = getSymbolAddress($2);
			instruction instr = {COP, {addrSymbol, $4, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Instruction table is full.");
				yyerror(err);
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
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {ADD, {temp, $1, $3}};       // Add the two terms with the result being in temp3
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full.");
			yyerror(err);
			exit(1);
		}
		$$ = temp;
	}
	;
Sub :   Terme tSUB Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {SUB, {temp, $1, $3}};       // Substract the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full.");
			yyerror(err);
			exit(1);
		}
		$$ = temp;
	}
	;
Mul :   Terme tMUL Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {MUL, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full.");
			yyerror(err);
			exit(1);
		}
		$$ = temp;
	}
	;
Div :   Terme tDIV Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {DIV, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full.");
			yyerror(err);
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
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {EQSUP, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full.");
			yyerror(err);
			exit(1);
		}
		$$ = temp;
	};
Eqinf : Terme tEQINF Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {EQINF, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		$$ = temp;
	};
Sup : Terme tSUP Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {SUP, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		$$ = temp;
	};
Inf : Terme tINF Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {INF, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		$$ = temp;
	};
Equal : Terme tEQUAL Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {EQUAL, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		$$ = temp;
	};
Nequal : Terme tNEQUAL Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {NEQUAL, {temp, $1, $3}};       // Add the two temporary vars with the result being in temp
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		$$ = temp;
	}
Or: Terme tOR Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {OR, {temp, $1, $3}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
		}
		$$ = temp;
	};
And: Terme tAND Terme
	{
		int temp = newTmp();
        if(temp == -1)
        {
            sprintf(err, "Memory space allocated to temporary variables is exhausted.");
            yyerror(err);
			exit(1);
        }
		instruction instr = {AND, {temp, $1, $3}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
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
		{
			int addr = getSymbolAddress($1);
			if(addr == -1)
			{
				sprintf(err, "'%s' is undefined.", $1);
				yyerror(err);
			}
			$$ = addr;
		}
	| tNB
		{
			int addrTemp =newTmp();
            if(addrTemp == -1)
            {
                sprintf(err, "Memory space allocated to temporary variables is exhausted.");
                yyerror(err);
				exit(1);
            }
			instruction instr = {AFC, {addrTemp, $1, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Instruction table is full");
				yyerror(err);
				exit(1);
			}
			$$ = addrTemp;
		}
	| InvokeFun
		{
			int addrTemp =newTmp();
			if(addrTemp == -1)
			{
				sprintf(err, "Memory space allocated to temporary variables is exhausted.");
				yyerror(err);
				exit(1);
			}
			instruction instr = {COP, {addrTemp, $1, -1}};
			if(addInstruction(instr) == -1)
			{
				sprintf(err, "Instruction table is full");
				yyerror(err);
				exit(1);
			}
			$$ = addrTemp;
		}
	;
Print : tPRINT tOP tID tCP
	{
		int addrSymbol = getSymbolAddress($3);
		if(addrSymbol == -1)
		{
			sprintf(err, " '%s' is undefined.", $3);
			yyerror(err);
			exit(1);
		}
		instruction instr = {PRI, {addrSymbol, -1, -1}};
		if(addInstruction(instr) == -1)
		{
			sprintf(err, "Instruction table is full");
			yyerror(err);
			exit(1);
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
    printInstrTable();
    interpret();
	fclose(f);
	return 0;
}

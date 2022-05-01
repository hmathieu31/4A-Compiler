/**
 * @file symbolTable.c
 * @author Hugo Mathieu (hmathieu@insa-toulouse.fr) @Ger0th
 * @brief Symbol table implementation for the compiler
 * @version 0.1
 * @date 2022-03-10
 *
 * @copyright Copyright (c) 2022
 *
 */

#include "symbolTable.h"
#include "macrologger.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

SymbolTable symbolTable;

FunctionTable functionTable;

int depth = -1;

int currentFunctionDepth = 0;

int newTmp()
{
    if (symbolTable.topSymbolIndex < BASE_ARGS - 1)
    {
        int addrTemp = symbolTable.topIndexTemp + 1;
        symbolTable.topIndexTemp += 1;
        return addrTemp;
    }
    else
    {
        fprintf(stderr, "Error: the symbol table is full of temp var.\n");
        return -1;
    }
}

void freeAddrsTemp()
{
    symbolTable.topIndexTemp = BASE_VAR_TEMP - 1;
}

void increaseDepth()
{
    depth++;
}

void decreaseDepth()
{
    depth--;
}

void increaseFunctionDepth()
{
    currentFunctionDepth++;
}

void resetFunctionDepth()
{
    currentFunctionDepth = 0;
}

void initTable()
{
    symbolTable.topSymbolIndex = -1;
    symbolTable.topIndexTemp = BASE_VAR_TEMP - 1;
    symbolTable.topIndexArgs = BASE_ARGS - 1;
    symbol symInit = {
        "",
        t_int,
        -1};
    for (int i = 0; i < BASE_ARGS - 1; i++)
    {
        symbolTable.symbolArray[i] = symInit;
    }
}

void initFunctionTable()
{
    Function funcInit = {
        "",
        -1,
        -1};
    for (int i = 0; i < FUNCTION_TABLE_SIZE; i++)
    {
        functionTable.functionArray[i] = funcInit;
    }
    functionTable.topFunctionIndex = -1;
}

int isSymbolTableEmpty()
{
    int empty = 0;
    if (symbolTable.topSymbolIndex == -1)
    {
        empty = 1;
    }
    return empty;
}

int addSymbol(char *symbolName, int sizeofSymbol, enum type typ)
{
    if (symbolTable.topSymbolIndex == BASE_VAR_TEMP - 1) // The symbol table being limited to 924 (BASE_VAR_TEMP) symbols, an error must be handled if trying to add another symbol
    {
        fprintf(stderr, "Symbol table is full. Program cannot compile!\n");
        return -1;
    }
    char *name = (char *)malloc(sizeofSymbol);
    strncpy(name, symbolName, sizeofSymbol);
    symbol sym = {name, typ, depth, currentFunctionDepth};
    symbolTable.topSymbolIndex += 1;
    symbolTable.symbolArray[symbolTable.topSymbolIndex] = sym;

    printf("Adding symbol '%s' to symbol table at depth %d and topindex is %d -- function depth: %d\n", symbolTable.symbolArray[symbolTable.topSymbolIndex].symbolName, symbolTable.symbolArray[symbolTable.topSymbolIndex].depth, symbolTable.topSymbolIndex, symbolTable.symbolArray[symbolTable.topSymbolIndex].functionDepth);
    return 0;
}

int addFunction(char *functionName, int functionAddress)
{
    if (functionTable.topFunctionIndex == FUNCTION_TABLE_SIZE - 1)
    {
        fprintf(stderr, "Function table is full. Program cannot compile!\n");
        return -1;
    }
    char *name = (char *)malloc(strlen(functionName) + 1);
    strcpy(name, functionName);
    functionTable.topFunctionIndex += 1;
    Function function = {name, functionAddress, -1, currentFunctionDepth};
    functionTable.functionArray[functionTable.topFunctionIndex] = function;
    return 0;
}

int setFunctionReturnAddress(char *functionName, int returnAddress)
{
    int i = 0;
    while (i < FUNCTION_TABLE_SIZE && strcmp(functionTable.functionArray[i].functionName, functionName) != 0)
    {
        i++;
    }
    if (i == FUNCTION_TABLE_SIZE)
    {
        fprintf(stderr, "Function '%s' not found in function table.\n", functionName);
        return -1;
    }
    functionTable.functionArray[i].returnAddress = returnAddress;
    return 0;
}

int getFunctionAddress(char *functionName)
{
    for (int i = 0; i < FUNCTION_TABLE_SIZE; i++)
    {
        if (strcmp(functionTable.functionArray[i].functionName, functionName) == 0)
        {
            return functionTable.functionArray[i].functionAddress;
        }
    }
    return -1;
}

int getFunctionDepth(char *functionName)
{
    for (int i = 0; i < FUNCTION_TABLE_SIZE; i++)
    {
        if (strcmp(functionTable.functionArray[i].functionName, functionName) == 0)
        {
            return functionTable.functionArray[i].functionAddress;
        }
    }
    return -1;
}

int setFunctionScope(char *functionName)
{
    for (int i = 0; i < FUNCTION_TABLE_SIZE; i++)
    {
        if (strcmp(functionTable.functionArray[i].functionName, functionName) == 0)
        {
            currentFunctionDepth = functionTable.functionArray[i].functionDepth;
            return 0;
        }
    }
    return -1;
}

int deleteSymbol()
{
    if (isSymbolTableEmpty())
    {
        fprintf(stderr, "Nothing to delete, empty stack!\n");
        exit(-1);
    }
    else
    {
        symbolTable.topSymbolIndex--;
    }
    return 0;
}

int deleteFromChangeScope()
{
    if (!isSymbolTableEmpty())
    {
        int i = symbolTable.topSymbolIndex;
        while (i >= 0 && symbolTable.symbolArray[i].depth > depth)
        {
            deleteSymbol();
            i--;
        }
    }
    return 0;
}

int getSymbolAddress(char *symbol)
{
    int symbolAddress = -1;
    int i = 0;
    while (i <= symbolTable.topSymbolIndex && symbolAddress == -1)
    {
        if (strcmp(symbolTable.symbolArray[i].symbolName, symbol) == 0 && symbolTable.symbolArray[i].functionDepth == currentFunctionDepth)
        {
            symbolAddress = i;
        }
        i++;
    }
    return symbolAddress;
}

int getTopIndex()
{
    return symbolTable.topSymbolIndex;
}

int getFunctionParameterAddress(char *functionName, int parameterIndex)
{
    int i = 0;
    while (i < FUNCTION_TABLE_SIZE && strcmp(functionTable.functionArray[i].functionName, functionName) != 0)
    {
        i++;
    }
    if (i == FUNCTION_TABLE_SIZE)
    {
        fprintf(stderr, "Function '%s' not found in function table.\n", functionName);
        return -1;
    }
    int functionDepth = functionTable.functionArray[i].functionDepth;
    int parameterAddress = -1;
    int parameterCount = 0;
    i = 0;
    while (parameterAddress == -1 && i <= symbolTable.topSymbolIndex)
    {
        symbol symbol = symbolTable.symbolArray[i];
        if (symbol.functionDepth == functionDepth && symbol.depth == -1) // Parameter variable have a depth of -1
        {
            parameterCount++;
        }
        if (parameterCount == parameterIndex)
        {
            parameterAddress = i;
        }
        i++;
    }
    if (parameterAddress == -1)
    {
        fprintf(stderr, "Parameter index %d not found in function '%s'\n", parameterIndex, functionName);
        return -1;
    }
    return parameterAddress;
}

int getFunctionReturnAddress(char *functionName)
{
    int functionReturnAddress = -1;
    int i = 0;
    while (i <= functionTable.topFunctionIndex && functionReturnAddress == -1)
    {
        if (strcmp(functionTable.functionArray[i].functionName, functionName) == 0)
        {
            functionReturnAddress = functionTable.functionArray[i].returnAddress;
        }
        i++;
    }
    if (i <= functionTable.topFunctionIndex)
    {
        functionTable.functionArray[i - 1].returnAddress = -1; // Reset of function return address once it has been retrieved
    }
    return functionReturnAddress;
}

int addArgument()
{
    if (symbolTable.topIndexArgs == SYMBOL_TABLE_SIZE - 1)
    {
        fprintf(stderr, "Argument table is full. Program cannot compile!\n");
        return -1;
    }
    symbolTable.topIndexArgs += 1;
    symbolTable.symbolArray[symbolTable.topIndexArgs].symbolName = NULL;
    symbolTable.symbolArray[symbolTable.topIndexArgs].typ = t_int;
    symbolTable.symbolArray[symbolTable.topIndexArgs].depth = -1;
    symbolTable.symbolArray[symbolTable.topIndexArgs].functionDepth = -1;
    return symbolTable.topIndexArgs;
}

int iterator = BASE_ARGS - 1;
int getNextArgumentAddress()
{
    int nextArgumentAddress = -1;
    if (iterator < symbolTable.topIndexArgs) // If there are arguments to be iterated on
    {
        nextArgumentAddress = iterator;
        iterator++;
    }
    return nextArgumentAddress;
}

void clearArgumentTable()
{
    symbolTable.topIndexArgs = BASE_ARGS - 1;
    iterator = BASE_ARGS - 1;
}

void printSymbolTable()
{
    for (int i = 0; i < symbolTable.topSymbolIndex; i++)
    {
        printf("Symbol : %s, depth : %d\n", symbolTable.symbolArray[i].symbolName, symbolTable.symbolArray[i].depth);
    }
}

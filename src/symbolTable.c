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
#include "stack.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int currentFunctionId;

SymbolTable symbolTable;

int depth = -1;

int newTmp()
{
    if (symbolTable.topSymbolIndex < BASE_ARGS)
    {
        symbolTable.topIndexTemp += 1;
        int addrTemp = symbolTable.topIndexTemp;
        symbol sym = {"temp", t_int, -1, currentFunctionId};
        symbolTable.symbolArray[addrTemp] = sym;
        return addrTemp;
    }
    else
    {
        return -1;
    }
}

void freeAddrsTemp()
{
    while (symbolTable.topIndexTemp > BASE_ARGS - 1 && symbolTable.symbolArray[symbolTable.topIndexTemp].functionId == currentFunctionId)
    {
        symbolTable.topIndexTemp -= 1;
    }
}

void increaseDepth()
{
    depth++;
}

void decreaseDepth()
{
    depth--;
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
    for (int i = 0; i < SYMBOL_TABLE_SIZE; i++)
    {
        symbolTable.symbolArray[i] = symInit;
    }
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
    if (symbolTable.topSymbolIndex == BASE_VAR_TEMP - 1) // The symbol table being limited to 924 (BASE_VAR_TEMP - 1) symbols, an error must be handled if trying to add another symbol
    {
        return -1;
    }
    char *name = (char *)malloc(sizeofSymbol);
    strncpy(name, symbolName, sizeofSymbol);
    symbol sym = {name, typ, depth, currentFunctionId};
    symbolTable.topSymbolIndex += 1;
    symbolTable.symbolArray[symbolTable.topSymbolIndex] = sym;

    LOG_DEBUG("Adding symbol '%s' to symbol table at depth %d and topindex is %d -- function depth: %d\n Current function scope = %d\n", symbolTable.symbolArray[symbolTable.topSymbolIndex].symbolName, symbolTable.symbolArray[symbolTable.topSymbolIndex].depth, symbolTable.topSymbolIndex, symbolTable.symbolArray[symbolTable.topSymbolIndex].functionId, currentFunctionId);
    return symbolTable.topSymbolIndex;
}


int deleteSymbol()
{
    if (isSymbolTableEmpty())
    {
        return -1;
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
            if (deleteSymbol() == -1)
            {
                return -1;
            }
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
        if (strcmp(symbolTable.symbolArray[i].symbolName, symbol) == 0 && symbolTable.symbolArray[i].functionId == currentFunctionId)
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

int addArgument()
{
    if (symbolTable.topIndexArgs == SYMBOL_TABLE_SIZE - 1)
    {
        return -1;
    }
    symbolTable.topIndexArgs += 1;
    symbolTable.symbolArray[symbolTable.topIndexArgs].symbolName = NULL;
    symbolTable.symbolArray[symbolTable.topIndexArgs].typ = t_int;
    symbolTable.symbolArray[symbolTable.topIndexArgs].depth = -1;
    symbolTable.symbolArray[symbolTable.topIndexArgs].functionId = -1;
    return symbolTable.topIndexArgs;
}

int iterator = BASE_ARGS;
int getNextArgumentAddress()
{
    int nextArgumentAddress = -1;
    if (iterator <= symbolTable.topIndexArgs) // If there are arguments to be iterated on
    {
        nextArgumentAddress = iterator;
        iterator++;
    }
    return nextArgumentAddress;
}

void clearArgumentTable()
{
    symbolTable.topIndexArgs = BASE_ARGS - 1;
    iterator = BASE_ARGS;
}

void printSymbolTable()
{
    for (int i = 0; i < symbolTable.topSymbolIndex; i++)
    {
        printf("Symbol : %s, depth : %d\n", symbolTable.symbolArray[i].symbolName, symbolTable.symbolArray[i].depth);
    }
}

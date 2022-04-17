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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

symbolTable table;

int depth = 0;

int newTmp()
{
    if (table.topSymbolIndex < TABLE_SIZE - 1)
    {
        int addrTemp = table.topIndexTemp + 1;
        table.topIndexTemp += 1;
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
    table.topIndexTemp = BASE_VAR_TEMP - 1;
}

int increaseDepth()
{
    depth++;
    return 0;
}

int decreaseDepth()
{
    depth--;
    return 0;
}

int initTable()
{
    table.topSymbolIndex = -1;
    table.topIndexTemp = BASE_VAR_TEMP - 1;
    symbol symInit = {
        "",
        t_int,
        -1};
    for (int i = 0; i < TABLE_SIZE - 1; i++)
    {
        table.symbolArray[i] = symInit;
    }
    return 0;
}

int isSymbolTableEmpty()
{
    int empty = 0;
    if (table.topSymbolIndex == -1)
    {
        empty = 1;
    }
    return empty;
}

int addSymbol(char *symbolName, int sizeofSymbol, enum type typ)
{
    if (table.topSymbolIndex == BASE_VAR_TEMP - 1) // The symbol table being limited to 924 (BASE_VAR_TEMP) symbols, an error must be handled if trying to add another symbol
    {
        fprintf(stderr, "Symbol table is full. Program cannot compile!\n");
        return -1;
    }
    char *name = (char *)malloc(sizeofSymbol);
    strncpy(name, symbolName, sizeofSymbol);
    symbol sym = {name, typ, depth};
    table.topSymbolIndex += 1;
    table.symbolArray[table.topSymbolIndex] = sym;

    // printf("Adding symbol '%s' to symbol table at depth %d and topindex is %d\n", table.symbolArray[table.topIndexSymbol].symbolName, table.symbolArray[table.topIndexSymbol].depth, table.topIndexSymbol);
    return 0;
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
        table.topSymbolIndex--;
    }
    return 0;
}

int deleteFromChangeScope() // TODO #1 Handle the changes of scope stemming from functions (defined before the main)
                            // TODO #29 Fix bug in change of scopes
{
    if (!isSymbolTableEmpty())
    {
        int i = table.topSymbolIndex;
        while (i >= 0 && table.symbolArray[i].depth == depth)
        {
            deleteSymbol();
            i--;
        }
    }
    return 0;
}

int getAddressSymbol(char *symbol)
{
    int symbolAddress = -1;
    int i = 0;
    while (i <= table.topSymbolIndex && symbolAddress == -1)
    {
        if (strcmp(table.symbolArray[i].symbolName, symbol) == 0)
        {
            symbolAddress = i;
        }
        i++;
    }
    return symbolAddress;
}

int getTopIndex()
{
    return table.topSymbolIndex;
}

void printSymbolTable()
{
    for (int i = 0; i < table.topSymbolIndex; i++)
    {
        printf("Symbol : %s, depth : %d\n", table.symbolArray[i].symbolName, table.symbolArray[i].depth);
    }
}

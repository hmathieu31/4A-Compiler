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

int depth;

void freeAddrsTemp()
{
    addr_temp1 = -1;
    addr_temp2 = -1;
}

int affectToAddrTemp(int value)
{
    if (addr_temp1 == -1)
    {
        addr_temp1 = value;
        return addr_temp1;
    }
    else if (addr_temp2 == -1)
    {
        addr_temp2 = value;
        return addr_temp2;
    }
    else
    {
        return 1;
    }
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
    table.topIndex = -1;
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

int isEmpty()
{
    int empty = 0;
    if (table.topIndex == -1)
    {
        empty = 1;
    }
    return empty;
}

int addSymbol(char *symbolName, int sizeofSymbol, enum type typ)
{
    if (table.topIndex == TABLE_SIZE - 1) // The symbol table being limited to 1024 (TABLE_SIZE) symbols, an error must be handled if trying to add another symbol
    {
        fprintf(stderr, "Symbol table is full. Program cannot compile!\n");
        return -1;
    }
    char *name = (char *)malloc(sizeofSymbol);
    strncpy(name, symbolName, sizeofSymbol);
    symbol sym = {name, typ, depth};
    table.topIndex += 1;
    table.symbolArray[table.topIndex] = sym;

    // printf("Adding symbol '%s' to symbol table at depth %d and topindex is %d\n", table.symbolArray[table.topIndex].symbolName, table.symbolArray[table.topIndex].depth, table.topIndex);
    return 0;
}

int deleteSymbol()
{
    if (isEmpty())
    {
        fprintf(stderr, "Nothing to delete, empty stack!\n");
        exit(-1);
    }
    else
    {
        table.topIndex--;
    }
    return 0;
}

int deleteFromChangeScope() // TODO #1 Handle the changes of scope stemming from functions (defined before the main)
{
    if (!isEmpty())
    {
        int i = table.topIndex;
        int deepestScope = table.symbolArray[i].depth;
        while (i >= 0 && table.symbolArray[i].depth == deepestScope)
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
    while (i <= table.topIndex && symbolAddress == -1)
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
    return table.topIndex;
}

void printSymbolTable()
{
    for (int i = 0; i < table.topIndex; i++)
    {
        printf("Symbol : %s, depth : %d\n", table.symbolArray[i].symbolName, table.symbolArray[i].depth);
    }
}

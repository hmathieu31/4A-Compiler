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
#include <string.h>
#include <stdlib.h>

symbolTable table;

int initTable()
{
    table.topIndex = -1;
    symbol symInit = {
        "",
        t_int,
        -1};
    for (int i = 0; i < TABLE_SIZE; i++)
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

int addSymbol(char *symbolName, enum type typ, int depth)
{
    if (table.topIndex == TABLE_SIZE) // The symbol table being limited to 1024 (TABLE_SIZE) symbols, an error must be handled if trying to add another symbol
    {
        fprintf(stderr, "Symbol table is full. Program cannot compile!\n");
        exit(-1);
    }
    char * name = (char*)malloc(sizeof(char*));
    strncpy(name, symbolName, sizeof(symbolName));
    symbol sym = {name, typ, depth};
    
    table.topIndex += 1;
    table.symbolArray[table.topIndex] = sym;
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

// int deleteFromChangeScope()
// {
//     if (!isEmpty())
//     {
//         symbol sym = table.sym;
//         int scope = sym.depth;
//         while (table.prev != NULL && sym.depth == scope)
//         {
//         }
//     }
// }

int getAddressSymbol(char *symbol)
{
    int symbolAddress = -1;
    int i = 0;
    while(i <= table.topIndex && symbolAddress == -1)
    {
        if (strcmp(table.symbolArray[i].symbolName, symbol) == 0)
        {
            symbolAddress = i;
        }
        i++;
    }
    if (symbolAddress == -1)
    {
        fprintf(stderr, "The symbol was not found in the symbol table \n");
        exit(-1);
    }
    return symbolAddress;
}

int getTopIndex()
{
    return table.topIndex;
}

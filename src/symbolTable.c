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

symbolTable table;

int initTable() {
    table.topIndex = -1;
    symbol symInit = {
        NULL,
        NULL,
        -1
    };
    for (int i = 0; i < TABLE_SIZE; i++)
    {
        table.symbolArray[i] = symInit;
    }
    return 0;
}

int deleteSymbol();

int isEmpty()
{
    if (symbolTable.topIndex==-1)
    {
        result=1;
    }
    else
    {
        result=0;
    };
    return result;
};
    
int addSymbol(char* symbolName, enum type typ, int depth)
{
    if (isEmpty())
    {
        symbolTable.symbolArray[0]={symbolName,typ,0};
        symbolTable.topIndex=0;
    }
    else
    {
        symbolTable.symbolArray[symbolTable.topIndex+1]={symbolName,index,typ,depth};
        (symboleTable.topIndex)++;      
    }
    return 0
};
   
int deleteSymbol()
{
    if isEmpty()
    {
        printf("Nothing to delete, empty stack!\n");
    }
    else
    {
    symboleTable.topIndex--;
    }
    return 0;
};

int deleteFromChangeScope() {
    if (!isEmpty()) {
        symbol sym = table.sym;
        int scope = sym.depth;
        while (table.prev != NULL && sym.depth == scope) {
        }
    }
}

int getAddressSymbol(char* symbol);

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

int addSymbol(char* symbolName, enum type typ, int depth);

int deleteSymbol(char* symbolName);

int isSymbolPresent(char* symbol) {
    int isPresent = 0;
    if (!isEmpty()) {
        while (table.prev != NULL && !isPresent) {
            isPresent = strcmp(table.sym.symbolName, symbol);
        }
    }
    return isPresent;
}

int deleteFromChangeScope() {
    if (!isEmpty()) {
        symbol sym = table.sym;
        int scope = sym.depth;
        while (table.prev != NULL && sym.depth == scope) {
        }
    }
}

int getAddressSymbol(char* symbol);

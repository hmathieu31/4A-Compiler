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

int addSymbol(char* symbolName, enum type typ, int depth);


int deleteSymbol(char* symbolName);


int isSymbolPresent(char* symbol){
    
}


int deleteFromChangeScope();


int getAddressSymbol(char* symbol);
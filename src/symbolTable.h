/**
 * @file symbolTable.h
 * @author Hugo Mathieu (hmathieu@insa-toulouse.fr) @Ger0th
 * @brief Symbol table for the compiler
 * @version 0.1
 * @date 2022-03-10
 * 
 * @copyright Copyright (c) 2022
 * 
 */


enum type {
    t_int
};


int addSymbol(char* symbolName, type typ, int depth);


int deleteSymbol(char* symbolName);


int isSymbolPresent(char* symbol);


int deleteFromChangeScope();


int getAddressSymbol(char* symbol);
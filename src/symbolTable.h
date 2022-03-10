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

#define TABLE_SIZE 1024

enum type {
    t_int
};

typedef struct symbol
{
    char* symbolName;
    int index;
    enum type typ;
    int depth;
} symbol;

symbol symbolTable[TABLE_SIZE];

int addSymbol(char* symbolName, enum type typ, int depth);


int deleteSymbol(char* symbolName);

/**
 * @brief Checks if the symbol is present in the table
 * 
 * @param symbol 
 * @return 1 if the symbol is present
 */
int isSymbolPresent(char* symbol);

int isEmpty();

/**
 * @brief Removes all symbols from 
 * 
 * @return int 
 */
int deleteFromChangeScope();


int getAddressSymbol(char* symbol);

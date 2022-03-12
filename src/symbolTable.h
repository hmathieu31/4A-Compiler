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

enum type
{
    t_int
};

typedef struct symbol
{
    char *symbolName;
    enum type typ;
    int depth;
} symbol;

typedef struct symbolTable
{
    symbol symbolArray[TABLE_SIZE];
    int topIndex;
} symbolTable;

/**
 * @brief Initializes the table at the start of the compilation
 *
 * @return 0 if executed correctly
 */
int initTable();

/**
 * @brief Add a new symbol to the table
 *
 * @param symbolName
 * @param typ For now t_int only
 * @param depth Corresponding to the scope of the variable (vars in main being at depth 0)
 * @return 0 if the symbol was correctly. Fails with -1 and prints an error message if trying to add a 1025e symbol
 */
int addSymbol(char *symbolName, enum type typ, int depth);

int deleteSymbol();

/**
 * @brief Checks if the symbolTable is empty.
 * 
 * @return 1 if the symbolTable is empty.
 */
int isEmpty();

/**
 * @brief Removes all symbols at the highest scope from the table
 *
 * @return 0 if executed correctly
 */
int deleteFromChangeScope();

/**
 * @brief Checks if the symbol is present in the table and returns its address if present
 *
 * @param symbol
 * @return The address of the symbol if the symbol is present. 0 otherwise
 */
int getAddressSymbol(char *symbol);

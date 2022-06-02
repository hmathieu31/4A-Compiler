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

#ifndef SYMBOLTABLES_H
#define SYMBOLTABLES_H

#define FUNCTION_JMP_ADDR 1024
#define SYMBOL_TABLE_SIZE 1024
#define BASE_ARGS 1009
#define BASE_VAR_TEMP 925

/* Typedefs -----------------------------------------------------------------*/
typedef enum type
{
    t_int
} type;

typedef struct symbol
{
    char *symbolName;
    type typ;
    int depth;
    int functionId;
} symbol;

typedef struct SymbolTable
{
    symbol symbolArray[SYMBOL_TABLE_SIZE];
    int topSymbolIndex;
    int topIndexTemp;
    int topIndexArgs;
} SymbolTable;

/* Function prototypes ------------------------------------------------------*/

/**
 * @brief Creates a new temporary variable in the symbol table.
 * The current function depth is stored as well.
 *
 * @return  The address of the new temporary variable. Or -1 if the table was full.
 */
int newTmp();

/**
 * @brief Free the temporary addresses.
 *
 */
void freeAddrsTemp();

/**
 * @brief Increases the depth of a variable when entering a new body (if or while)
 *
 */
void increaseDepth();

/**
 * @brief Decreases the depth of a variable when exiting a new body (if or while)
 *
 */
void decreaseDepth();

/**
 * @brief Initialise the table at the start of the compilation
 *
 */
void initTable();

/**
 * @brief Add a new symbol to the table
 *
 * @param symbolName
 * @param size_of_symbol The size of the symbol in bytes
 * @param type For now int only
 * @return The address of the symbol if added correctly. -1 if the symbol could not be added. (table full)
 */
int addSymbol(char *symbolName, int sizeofSymbol, enum type typ);

/**
 * @brief Delete the symbol at the top of the table.
 *
 * @return 1 if the symbol was successfully deleted. Fails with -1 and prints an error message if trying to delete while table is empty.
 */
int deleteSymbol();

/**
 * @brief Checks if the SymbolTable is empty.
 *
 * @return 1 if the SymbolTable is empty.
 */
int isSymbolTableEmpty();

/**
 * @brief Removes all symbols at the highest scope from the table
 *
 * @return 0 if executed correctly. -1 if the table is empty.
 */
int deleteFromChangeScope();

/**
 * @brief Checks if the symbol is present in the table and returns its address if present
 *
 * @param symbol
 * @return The address of the symbol if the symbol is present. -1 if the symbol is not present
 */
int getSymbolAddress(char *symbol);

/**
 * @brief Get the Top Index of the SymbolTable (Testing purposes)
 *
 * @return the index of the top.
 */
int getTopIndex();

/**
 * @brief Add a new argument to the table of arguments (subsection of the table of symbols)
 *
 * @return The address of the added arguments if the argument was correctly added. -1 if the argument could not be added. (table full)
 */
int addArgument();

/**
 * @brief Get the next available argument address
 *
 * @return The address of the next argument. -1 if there are no more arguments (or no arguments were defined).
 */
int getNextArgumentAddress();

/**
 * @brief Clears all the arguments in the table
 *
 */
void clearArgumentTable();

/**
 * @brief Testing function displaying the table of symbols.
 * Called when the program has finished running.
 *
 */
void printSymbolTable();

#endif

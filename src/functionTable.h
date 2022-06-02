/**
 * @file functionTable.h
 * @author Hugo Mathieu (hmathieu@insa-toulouse.fr)
 * @brief Module that contains the function table and interface to access it
 * @version 0.1
 * @date 2022-06-01
 * 
 * @copyright Copyright (c) 2022
 * 
 */
#ifndef FUNCTIONTABLE_H
#define FUNCTIONTABLE_H

#define FUNCTION_TABLE_SIZE 64

/** Typedefs -----------------------------------------------------------------*/

/**
 * @brief Struct containing the different elements composing a function
 * 
 */
typedef struct Function
{
    char *functionName; /* Name of the function */
    int functionAddress; /* Address of the first instruction of the function */
    int returnAddress; /* Address of the return instruction */
    int functionId; /* ID of the function */
    int returnVarAddress; /* Address of the return variable in symbol table */
} Function;

typedef struct FunctionTable
{
    Function functionArray[FUNCTION_TABLE_SIZE];
    int topFunctionIndex;
} FunctionTable;

/* Global variables ----------------------------------------------------------*/

int currentFunctionId = 0;

/* Function prototypes -------------------------------------------------------*/

/**
 * @brief Initializes the function table at the start of the compilation
 *
 */
void initFunctionTable();

/**
 * @brief Increases per 1 the Id of the function (which will be used for all the symbols defined inside).
 * Called during the function declarations.
 *
 */
void increaseFunctionId();

/**
 * @brief Reset the current function Id to 0 when entering the main.
 *
 */
void resetFunctionId();

/**
 * @brief Add a new function name to the function table
 *
 * @param functionName
 * @param functionAddress The address of the first line of assembler code of the function
 * @return 0 if the function was correctly. -1 if the function could not be added. (table full)
 */
int addFunction(char *FunctionName, int functionAddress);

/**
 * @brief Checks if the functions has been defined
 * 
 * @param FunctionName 
 * @return 1 if the function has been defined. 0 otherwise.
 */
int isFunctionDefined(char * FunctionName);

/**
 * @brief Add a new function scope value to the scopes stack.
 * 
 * @param scope 
 */
void pushScope(int scope);

/**
 * @brief Returns the upper scope of the current scope and removes it from the stack.
 * 
 * @return The scope at the top of the stack. -1 if the stack is empty.
 */
int popScope();

/**
 * @brief Get the scope at the top of the stack.
 * 
 * @return The scope at the top of the stack. -1 if the stack is empty.
 */
int getTopScope();

/**
 * @brief Checks if the function has been declared and returns the address of its first line of code if present
 *
 * @param functionName
 * @return The function structure corresponding to the function name. -1 if the function is not present
 */
Function getFunction(char *functionName);

/**
 * @brief Set the the current function scope to the scope corresponding of the function going to (materialised by its ID).
 *
 * @param functionName
 * @return 0 if effected correclty. -1 if the function could not be found.
 */
int setFunctionScope(char *functionName);

/**
 * @brief When exiting a function call, go to the function scope (materialised by its ID) invoking.
 *
 */
void decreaseFunctionScope();

/**
 * @brief Set the address of the return instruction in the function
 *
 * @param functionName
 * @param returnAddress The address of the return instruction in the function
 * @return 0 if the operation executed correctly. -1 if the function could not be found.
 */
int setFunctionReturnAddress(char *functionName, int returnAddress);

/**
 * @brief Set the address of the return variable (_ret symbol) in the function
 *
 * @param returnVarAddress The address of the return variable of the function in the symbolTable
 * @return 0 if the operation executed correctly. -1 if the function could not be found.
 */
int setFunctionReturnVarAddress(int returnVarAddress);

/**
 * @brief Get the address of the functions's parameter of given index
 *
 * @param functionName Name of the function
 * @param parameterIndex Index of the parameter (starting at 1)
 * @return The address of the parameter. -1 if the function could not be found. -2 if the parameter index is invalid.
 */
int getFunctionParameterAddress(char *functionName, int parameterIndex);

#endif
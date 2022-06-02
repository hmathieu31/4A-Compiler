/**
 * @file functionTable.c
 * @author Hugo Mathieu (hmathieu@insa-toulouse.fr)
 * @brief Module that contains the function table and interface to access it
 * @version 0.1
 * @date 2022-06-01
 *
 * @copyright Copyright (c) 2022
 *
 */

#include <stdlib.h>
#include <string.h>

#include "functionTable.h"
#include "symbolTable.h"
#include "stack.h"

/* Variables -----------------------------------------------------------------*/

FunctionTable functionTable;

extern SymbolTable symbolTable;

/* Global functions ----------------------------------------------------------*/

void increaseFunctionId()
{
    currentFunctionId++;
}

void resetFunctionId()
{
    currentFunctionId = 0;
}

void initFunctionTable()
{
    Function funcInit = {
        "",
        -1,
        -1,
        -1};
    for (int i = 0; i < FUNCTION_TABLE_SIZE; i++)
    {
        functionTable.functionArray[i] = funcInit;
    }
    functionTable.topFunctionIndex = -1;
}

int addFunction(char *functionName, int functionAddress)
{
    if (functionTable.topFunctionIndex == FUNCTION_TABLE_SIZE - 1)
    {
        return -1;
    }
    char *name = (char *)malloc(strlen(functionName) + 1);
    strcpy(name, functionName);
    functionTable.topFunctionIndex += 1;
    Function function = {name, functionAddress, -1, currentFunctionId};
    functionTable.functionArray[functionTable.topFunctionIndex] = function;
    return 0;
}

int isFunctionDefined(char *functionName)
{
    int defined = 0;
    for (int i = 0; i < functionTable.topFunctionIndex + 1; i++)
    {
        if (strcmp(functionTable.functionArray[i].functionName, functionName) == 0)
        {
            defined = 1;
        }
    }
    return defined;
}

int setFunctionReturnAddress(char *functionName, int returnAddress)
{
    int i = 0;
    while (i < FUNCTION_TABLE_SIZE && strcmp(functionTable.functionArray[i].functionName, functionName) != 0)
    {
        i++;
    }
    if (i == FUNCTION_TABLE_SIZE)
    {
        return -1;
    }
    functionTable.functionArray[i].returnAddress = returnAddress;
    return 0;
}

int setFunctionReturnVarAddress(int returnVarAddress)
{
    int i = 0;
    while (i < FUNCTION_TABLE_SIZE && functionTable.functionArray[i].functionId != currentFunctionId)
    {
        i++;
    }
    if (i == FUNCTION_TABLE_SIZE)
    {
        return -1;
    }
    functionTable.functionArray[i].returnVarAddress = returnVarAddress;
    return 0;
}

Function getFunction(char *functionName)
{
    int i = 0;
    while (i < FUNCTION_TABLE_SIZE && strcmp(functionTable.functionArray[i].functionName, functionName) != 0)
    {
        i++;
    }
    if (i == FUNCTION_TABLE_SIZE)
    {
        Function funcFault = {
            "",
            -1,
            -1,
            -1};
        return funcFault;
    }
    return functionTable.functionArray[i];
}

int setFunctionScope(char *functionName)
{
    for (int i = 0; i < FUNCTION_TABLE_SIZE; i++)
    {
        if (strcmp(functionTable.functionArray[i].functionName, functionName) == 0)
        {
            pushScope(currentFunctionId);
            currentFunctionId = functionTable.functionArray[i].functionId;
            return 0;
        }
    }
    return -1;
}

void decreaseFunctionScope()
{
    popScope();
    currentFunctionId = getTopScope();
}

int getFunctionParameterAddress(char *functionName, int parameterIndex)
{
    int i = 0;
    while (i < FUNCTION_TABLE_SIZE && strcmp(functionTable.functionArray[i].functionName, functionName) != 0)
    {
        i++;
    }
    if (i == FUNCTION_TABLE_SIZE)
    {
        return -1;
    }
    int functionId = functionTable.functionArray[i].functionId;
    int parameterAddress = -1;
    int parameterCount = 0;
    i = 0;
    while (parameterAddress == -1 && i <= symbolTable.topSymbolIndex)
    {
        if (symbolTable.symbolArray[i].functionId == functionId && symbolTable.symbolArray[i].depth == -1) // Parameter variables have a depth of -1
        {
            parameterCount++;
        }
        if (parameterCount == parameterIndex)
        {
            parameterAddress = i;
        }
        i++;
    }
    if (parameterAddress == -1)
    {
        return -2;
    }
    return parameterAddress;
}
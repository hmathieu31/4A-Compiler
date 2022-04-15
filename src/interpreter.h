/**
 * @file interpreter.h
 * @author Hugo Mathieu (hmathieu@insa-toulouse.fr)
 * @brief 
 * @version 0.1
 * @date 2022-04-14
 * 
 * @copyright Copyright (c) 2022
 * 
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAILLE 1025

/**
 * @brief Initialize the symbol interpreterTable with -1
 * 
 */
void initSymbolTable();

/**
 * @brief Runs the interpreter on the instruction interpreterTable
 * 
 */
void interpret();
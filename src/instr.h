#include <stdio.h>
#include <stdlib.h>

#define TAILLE 1025

/**
 * @brief Initializes the array of instructions to ""
 * 
 */
void initArrays();

/**
 * @brief Adds an instruction (string) to the array
 * 
 * @param instr Asm instruction to add (string)
 * @return 0 if executed successfully.
 */
int addInstruction(char* instr);

/**
 * @brief Prints the entire array of instructions.
 * 
 * @return 0 if executed successfully.
 */
int printTable();
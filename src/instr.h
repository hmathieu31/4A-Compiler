#include <stdio.h>
#include <stdlib.h>

#ifndef INSTR_H
#define INSTR_H

#define TAILLE 1025

/**
 * @brief Initializes the array of instructions to ""
 * 
 */
void initArray();

/**
 * @brief Adds an instruction (string) to the array
 * 
 * @param instr Asm instruction to add (string)
 * @return 0 if executed successfully.
 */
int addInstruction(char* instr, int sizeofInstr);

/**
 * @brief Prints the entire array of instructions.
 * 
 * @return 0 if executed successfully.
 */
int printTable();

#endif
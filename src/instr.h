/**
 * @file instr.h
 * @author Hugo Mathieu (hmathieu@insa-toulouse.fr) Guillaume Aubut (@Ger0th)
 * @brief
 * @version 0.1
 * @date 2022-03-19
 *
 * @copyright Copyright (c) 2022
 *
 */
#include <stdio.h>
#include <stdlib.h>

#ifndef INSTR_H
#define INSTR_H

#define TAILLE 1025

typedef enum operator {
    MOV,
    MOV_I,
    ADD,
    SUB,
    MUL,
    DIV
} operator;

static const char* const operator_string[] = {
    [MOV] = "MOV",
    [MOV_I] = "MOV_I",
    [ADD] = "ADD",
    [SUB] = "SUB",
    [MUL] = "MUL",
    [DIV] = "DIV"
};

typedef struct instruction
{
    operator ope;
    int ops[2];
} instruction;

/**
 * @brief Initializes the array of instructions to instructions without specified operator and operands to -1
 *
 */
void initArray();

/**
 * @brief Adds an instruction (string) to the array
 *
 * @param instr Asm instruction to add (string)
 * @return 0 if executed successfully.
 */
int addInstruction(instruction instr);

/**
 * @brief Prints the entire array of instructions.
 *
 * @return 0 if executed successfully.
 */
int printTable();

/**
 * @brief Function to convert an instruction to a string.
 *
 * @param instr Structure instruction to convert.
 * @return Formatted string representation of the instruction.
 */
char *stringOfInstruction(instruction instr);

#endif
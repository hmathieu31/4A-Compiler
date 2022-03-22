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
    ADD,
    SUB,
    MUL,
    DIV,
    COP,
    AFC,
    JMP,
    JMF,
    INF,
    SUP,
    EQU,
    PRI
} operator;

static const char* const operator_string[] = {
    [ADD] = "ADD",
    [SUB] = "SUB",
    [MUL] = "MUL",
    [DIV] = "DIV",
    [COP]= "COP",
    [AFC]= "AFC",
    [JMP]= "JMP",
    [JMF]= "JMF",
    [INF]= "INF",
    [SUP]= "SUP",
    [EQU]= "EQU",
    [PRI]= "PRI"
};

typedef struct instruction
{
    operator ope;
    int ops[3];
} instruction;

/**
 * @brief Initializes the array of instructions to instructions without specified operator and operands to -1
 *
 */
void initArray();

/**
 * @brief Adds an instruction to the array
 *
 * @param instr Asm instruction to add
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
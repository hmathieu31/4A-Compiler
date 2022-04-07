/**
 * @file instr.c
 * @author Hugo Mathieu (hmathieu@insa-toulouse.fr) Guillaume Aubut (@Ger0th)
 * @brief
 * @version 0.1
 * @date 2022-03-19
 *
 * @copyright Copyright (c) 2022
 *
 */
#include "instr.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAILLE 1025

instruction instrArray[TAILLE];

void initArray()
{
    instruction instrInit;
    for (int i = 0; i < 2; i++)
    {
        instrInit.ops[i] = -1;
    }
    for (int i = 0; i < TAILLE - 1; i++)
    {
        instrArray[i] = instrInit;
    }
}

int addInstruction(instruction instr)
{
    int i = 0;
    while (i < TAILLE - 1 && instrArray[i].ops[0] == -1)
    {
        i++;
    }
    if (i == TAILLE - 1)
    {
        fprintf(stderr, "Maximum instruction array size exceeded\n");
        exit(1);
    }
    instrArray[i] = instr;
    return 0;
}

int printTable()
{
    for (int i = 0; i < TAILLE - 1; i++)
    {
        printf(stringOfInstruction(instrArray[i]));
    }
    return 0;
}

char *stringOfInstruction(instruction instruction)  // TODO #3 Test the function
{
    if (instruction.ops[0] == -1)
    {
        fprintf(stderr, "No instruction passed");
        exit(1);
    }

    char *str_out = "Instruction: ";
    char *str_operator = operator_string[instruction.ope];
    strcat(str_out, str_operator);
    strcat(str_out, "  ");

    char *operands = "";
    int i = 0;
    while (instruction.ops[i] != -1 && i < 3)
    {
        int length = sprintf(NULL, 0, "%d", instruction.ops[i]);
        char *op = malloc(length + 3);
        snprintf(op, length + 1, "%d  ", instruction.ops[i]);
        strcat(operands, op);
        i++;
    }

    return str_out;
}
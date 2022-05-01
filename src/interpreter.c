/**
 * @file interpreter.c
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

#include "instr.h"

#define TAILLE 1025

int interpreterTable[TAILLE];

void initInterpretTable()
{
    for (int i = 0; i < TAILLE - 1; i++)
    {
        interpreterTable[i] = -1;
    }
}

int getEntryPoint()
{
    int entryPoint = -1;
    int i = 0;
    while (entryPoint == -1 && i < TAILLE - 1)
    {
        if (getInstruction(i).ope == ENTRY)
        {
            entryPoint = i;
        }
        i++;
    }
    return entryPoint;
}

void interpret()
{
    initInterpretTable();

    int i = getEntryPoint();
    if (i == -1)
    {
        fprintf(stderr, "No entry point found\n");
        exit(-1);
    }
    instruction instr = getInstruction(i + 1);
    while (instr.ope != -1)
    {
        instr = getInstruction(i);
        switch (instr.ope)
        {
        case ENTRY:
            printf("Entry point\n");
        case ADD:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] + interpreterTable[instr.ops[2]];
            break;
        case SUB:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] - interpreterTable[instr.ops[2]];
            break;
        case MUL:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] * interpreterTable[instr.ops[2]];
            break;
        case DIV:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] / interpreterTable[instr.ops[2]];
            break;
        case COP:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]];
            break;
        case AFC:
            interpreterTable[instr.ops[0]] = instr.ops[1];
            break;
        case JMP:
            i = instr.ops[0];
            break;
        case JMF:
            if (interpreterTable[instr.ops[0]] == 0)
            {
                i = instr.ops[1];
            }
            break;
        case INF:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] < interpreterTable[instr.ops[2]];
            break;
        case SUP:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] > interpreterTable[instr.ops[2]];
            break;
        case EQUAL:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] == interpreterTable[instr.ops[2]];
            break;
        case NEQUAL:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] != interpreterTable[instr.ops[2]];
            break;
        case EQINF:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] <= interpreterTable[instr.ops[2]];
            break;
        case AND:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] && interpreterTable[instr.ops[2]];
            break;
        case OR:
            interpreterTable[instr.ops[0]] = interpreterTable[instr.ops[1]] || interpreterTable[instr.ops[2]];
            break;
        case PRI:
            printf("%d\n", interpreterTable[instr.ops[0]]);
            break;
        default:
            printf("Unknown instruction\n");
            break;
        }
        i++;
    }
}
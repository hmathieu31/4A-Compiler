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

char* instrArray[TAILLE];

void initArray() {
    for (int i = 0; i < TAILLE - 1; i++) {
        instrArray[i] = "";
    }
}

int addInstruction(char* instr, int sizeofInstr) {
    int i = 0;
    while (i < TAILLE - 1 && strcmp(instrArray[i], "")) {
        i++;
    }
    if (i == TAILLE - 1) {
        fprintf(stderr, "Maximum array size exceeded\n");
        exit(1);
    }
    char* nameInstr = (char*)malloc(sizeofInstr);
    strncpy(nameInstr, instr, sizeofInstr);
    instrArray[i] = nameInstr;
    return 0;
}

int printTable() {
    for (int i = 0; i < TAILLE - 1; i++) {
        printf(instrArray[i]);
    }
    return 0;
}
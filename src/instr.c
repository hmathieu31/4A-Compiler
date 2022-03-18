#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "instr.h"

#define TAILLE 1025

char* instrArray[TAILLE];


void initArray() {
    for (int i = 0; i < TAILLE - 1; i++) {
        instrArray[i] = "";
    }
}

int addInstruction(char* instr) {
    int i = 0;
    while (i < TAILLE - 1 && instrArray[i] != "") {
        i++;
    }
    if (i == TAILLE - 1) {
        fprintf(stderr, "Maximum array size exceeded\n");
        exit(1);
    }
    instrArray[i] = instr;
}

int printTable()
{
    for(int i=0; i<TAILLE-1;i++)
    {
        printf(instrArray[i]);
    }
};
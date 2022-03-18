#include <stdio.h>
#include <stdlib.h>

#define TAILLE 1025

char* instrArray[TAILLE];

int afficherTable()
{
    for(int i=0; i<TAILLE-1;i++)
    {
        printf(instrArray[i]);
    }
};
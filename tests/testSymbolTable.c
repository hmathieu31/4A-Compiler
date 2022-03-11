#include "../src/symbolTable.h"
#include <stdio.h>
#include <stdlib.h>

int test_addSymbol()
{
    for (int i = 0; i < 1023; i++)
    {
        char buf[4];
        itoa(i, buf, 10);
        addSymbol(buf, t_int, 0);
    }
    // if (addSymbol("err", t_int, 1) != -1)
    // {
    //     exit(1);
    // }
    return 0;
}

int test_isEmpty()
{
    if (!isEmpty())
    {
        exit(1);
    }
    addSymbol("a", t_int, 0);
    if (isEmpty())
    {
        exit(1);
    }
    return 0;
}

int main(int argc, char const *argv[])
{
    initTable();
    if (test_isEmpty())
    {
        fprintf(stderr, "Test - isEmpty - FAILED");
    }
    else if (test_addSymbol())
    {
        fprintf(stderr, "Test - addSymbol - FAILED");
    } else
    {
        fprintf(stdout, "All tests PASSED");
    }
    

    return 0;
}

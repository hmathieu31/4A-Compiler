#include "../src/symbolTable.h"
#include <stdio.h>
#include <stdlib.h>

int test_addOneSymbol()
{
    addSymbol("a", t_int, 0);
    if (isEmpty())
    {
        exit(1);
    }

    return 0;
}

int test_addMultipleSymbols()
{
    char buf[256];
    for (int i = 0; i < 1023; i++)
    {
        itoa(i, buf, sizeof(buf));
        addSymbol(buf, t_int, 0);
    }
    if (isEmpty())
    {
        exit(1);
    }
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

int test_TableOverflow()
{
    test_addMultipleSymbols();
    if (addSymbol("a", t_int, 0) != -1)
    {
        exit(1);
    }
    return 0;
}

int main(int argc, char const *argv[])
{
    int allTestsPassed = 1;
    initTable();

    if (test_isEmpty())
    {
        fprintf(stderr, "Test - isEmpty - FAILED ❌ \n");
        allTestsPassed = 0;
    }
    else
    {
        printf("Test - isEmpty - PASSED ✅\n");
    }

    if (test_addOneSymbol())
    {
        fprintf(stderr, "Test - test_addOneSymbol - FAILED ❌\n");
        allTestsPassed = 0;
    }
    else
    {
        printf("Test - test_addOneSymbol - PASSED ✅ \n");
    }

    if (test_addMultipleSymbols())
    {
        fprintf(stderr, "Test - test_addMultipleSymbols - FAILED ❌ \n");
        allTestsPassed = 0;
    }
    else
    {
        printf("Test - test_addMultipleSymbols - PASSED ✅ \n");
    }

    initTable();
    if (test_TableOverflow())
    {
        fprintf(stderr, "Test - test_TableOverflow - FAILED ❌ \n");
    } else
    {
        printf("Test - test_TableOverflow - PASSED ✅ \n");
        allTestsPassed = 0;
    }
    
    

    if (allTestsPassed)
    {
        printf("\n -- All test passed ✅ -- \n");
    }

    return 0;
}

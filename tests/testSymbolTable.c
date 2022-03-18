#include <stdio.h>
#include <stdlib.h>

#include "../src/symbolTable.h"

int test_addOneSymbol() {
    addSymbol("a", t_int);
    if (isEmpty()) {
        return (1);
    }

    return 0;
}

int test_addMultipleSymbols() {
    char buf[256];
    for (int i = 0; i < 1024; i++) {
        sprintf(buf, "%d", i);
        addSymbol(buf, t_int);
    }
    if (isEmpty()) {
        return (1);
    }
    return 0;
}

int test_isEmpty() {
    if (!isEmpty()) {
        return (1);
    }
    addSymbol("a", t_int);
    if (isEmpty()) {
        return (1);
    }
    return 0;
}

int test_TableOverflow() {
    test_addMultipleSymbols();
    if (addSymbol("a", t_int) != -1) {
        return (1);
    }
    return 0;
}

int test_deleteSymbol() {
    initTable();
    addSymbol("a", t_int);
    if (isEmpty()) {
        return (1);
    }
    deleteSymbol("a");
    if (!isEmpty()) {
        return (1);
    }
    return 0;
}

int test_getAddressSymbol() {
    initTable();
    addSymbol("toto", t_int);
    addSymbol("a", t_int);
    addSymbol("b", t_int);
    addSymbol("c", t_int);
    addSymbol("pouf", t_int);
    int add = getAddressSymbol("toto");
    if (add != 0) {
        return (1);
    }
    add = getAddressSymbol("pouf");
    if (add != 4) {
        return (1);
    }
    add = getAddressSymbol("b");
    if (add != 2) {
        return (1);
    }

    return 0;
}

int test_deleteFromChangeScope() {
    initTable();
    addSymbol("toto", t_int);
    addSymbol("a", t_int);
    addSymbol("b", t_int);
    addSymbol("c", t_int);
    addSymbol("pouf", t_int);
    deleteFromChangeScope();
    int top = getTopIndex();
    if (top != 1) {
        return 1;
    }
    return 0;
}

int main(int argc, char const *argv[]) {
    int allTestsPassed = 1;
    initTable();

    if (test_isEmpty()) {
        fprintf(stderr, "Test - isEmpty - FAILED ❌ \n");
        allTestsPassed = 0;
    } else {
        printf("Test - isEmpty - PASSED ✅\n");
    }

    if (test_addOneSymbol()) {
        fprintf(stderr, "Test - test_addOneSymbol - FAILED ❌\n");
        allTestsPassed = 0;
    } else {
        printf("Test - test_addOneSymbol - PASSED ✅ \n");
    }

    if (test_addMultipleSymbols()) {
        fprintf(stderr, "Test - test_addMultipleSymbols - FAILED ❌ \n");
        allTestsPassed = 0;
    } else {
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

    if (test_deleteSymbol()) {
        fprintf(stderr, "Test - test_deleteSymbol - FAILED ❌ \n");
        allTestsPassed = 0;
    } else {
        printf("Test - test_deleteSymbol - PASSED ✅ \n");
    }

    if (test_getAddressSymbol()) {
        fprintf(stderr, "Test - test_getAddressSymbol- FAILED ❌ \n");
        allTestsPassed = 0;
    } else {
        printf("Test - test_getAddressSymbol - PASSED ✅ \n");
    }

    if (test_deleteFromChangeScope()) {
        fprintf(stderr, "Test - test_deleteFromChangeScope - FAILED ❌ \n");
        allTestsPassed = 0;
    } else {
        fprintf(stderr, "Test - test_deleteFromChangeScope - PASSED ✅ \n");
        allTestsPassed = 0;
    }

    if (allTestsPassed) {
        printf("\n -- All test passed ✅ -- \n");
    }

    return 0;
}

#include "../src/instr.h"

int main(int argc, char const *argv[])
{
    instruction instr = {
        .ope = ADD,
        .ops = {
            1,
            2,
            3
        }
    };
    char * str = stringOfInstruction(instr);
    printf("%s\n", str);
    return 0;
}

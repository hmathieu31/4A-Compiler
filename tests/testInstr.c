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
    instruction instr2 = {
        .ope = SUB,
        .ops = {
            1,
            2,
            3
        }
    };
    char * str2 = stringOfInstruction(instr2);
    printf("%s\n", str2);
    return 0;
}

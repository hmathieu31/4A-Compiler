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
    instruction instr3 = {
        .ope = MUL,
        .ops = {
            1,
            -1,
            -1
        }
    };
    instruction instr4 = {
        .ope = DIV,
        .ops = {
            -1,
            -1,
            -1
        }
    };
    char * str3 = stringOfInstruction(instr3);
    printf("%s\n", str3);
    char * str4 = stringOfInstruction(instr4);
    printf("%s\n", str4);
    return 0;
}
